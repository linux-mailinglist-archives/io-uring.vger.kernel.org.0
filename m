Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C30B32C5CD
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhCDAYY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448762AbhCCWwB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 17:52:01 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84660C061763
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 14:51:10 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n14so27639217iog.3
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 14:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jkzaHDmTkBHODt1WjVbgPR48CKiEaxtUsO+VNZNhYrg=;
        b=ntt3x+/5daP2OHMLRkxesZxOn5fFMYhrAVnDEELfsLfjchH1bwaNvRb6a+5j23sPdH
         eoMwJzQa0VySN5WvrGKcunWxWJ0VlcXNpEkp14cq0IU+p/cdGEW0905qVkPLseEdeO6w
         nTig+SbDfWlJfcGlx13qtyahwexv94CMu+itWU7UBnQbgzlqKMAVBOtEEqib26qBCzjr
         R309t8UVXPOOi4S8Bu6lkDtbn0WZ1WQEOu2nyOZw9KHHTSIrxVfdFiIy5CMxgkOnwXcE
         kZyNmOeZb1BW+kFFsFUxs9TZNTeB4LFhlbmQN2uglFzmeH5oApt5uFvQot496kGoReL0
         b+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jkzaHDmTkBHODt1WjVbgPR48CKiEaxtUsO+VNZNhYrg=;
        b=toep6b5oN8ITbpd/wELAstaKRBdqG6eW8BcA0E8RjMsAQreff5Cl2FZd8KOe0OascD
         e/svL6oTqqQp9dqLpxKe3SAhZk217M5cN3otJ8PmfPLU+2wrqudo8N+D11aR5ZFTL58F
         WeapAsOct4bI2xgNBU/EFEcfMVSiK7bctUzJuxj846ZyhssDsqLLR5i76ZrCVH0KGA3S
         wwYl3hPz3yiJY5bqavVG/vJ2/v2QA+gVlSNDrBZiYLV1X8etNArwz5ELAYVJaEcqcyZ6
         opBHcgzFq15+89AnpZPFh593W2zp59AeV8p4Wse4nWwltyqiczrvhWEVwDDFCjtSVtH7
         43hQ==
X-Gm-Message-State: AOAM533JGI1UVECyF1xHguE1+dGH+nM7SxkJQpfYQKZOBMdqsxeyIaXb
        qZhpssxyNbqSsrvIVmVJeRJ4aQ==
X-Google-Smtp-Source: ABdhPJxcT/1+ki8D/dqM2vDVIGQ7Q7c9/G0PwbdOblR9vU7tZmdRZByv7K8+Rwqo1s7ZunQKRwELZA==
X-Received: by 2002:a02:a889:: with SMTP id l9mr1234532jam.1.1614811869882;
        Wed, 03 Mar 2021 14:51:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y18sm3170152ili.16.2021.03.03.14.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Mar 2021 14:51:09 -0800 (PST)
Subject: Re: memory leak in io_submit_sqes (2)
To:     syzbot <syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000002261d05bca94f7b@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8494c673-180e-e0b9-4db7-04aed2aee791@kernel.dk>
Date:   Wed, 3 Mar 2021 15:51:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000002261d05bca94f7b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block leak

-- 
Jens Axboe

