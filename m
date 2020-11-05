Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63DF2A83FD
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKEQuN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 11:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730854AbgKEQuM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 11:50:12 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175B8C0613D3
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 08:50:11 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p7so2462804ioo.6
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 08:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LCPf3w7GcOJmMavuxhhy8i+MWkFz77vU9ZNMmXvF0yc=;
        b=VVR99qiiNqLDP9i/eEOA1EFzfdcblQnmRz2qyvWNKrGxDPcquvdkCgI8+n/9r7CS6t
         yRYsInxCLko0aWTyBGm3zxhukaV26969+cHrzdx+Ro4IyE1HgvD9Ier/eMvLlOnZLxUq
         QMWzMjGcevlzjPbbkoubZ5AYtNhlCW3NQ5fpXqqlGoz1wuAzRM1IpdfTMAP53dNJbgVP
         cmv6RNSDLi/tFBz8FPNu+sf1TCkiLa9PpTr//p5JS0AMct7dJvi10TBpgMVwesx3jrpX
         QfU6tzIph3ojSh3gtXVUAdvsnptE0iKFN88PAxKYgrMfUFfOTQOyagMuW9JfuxlygUiQ
         pigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LCPf3w7GcOJmMavuxhhy8i+MWkFz77vU9ZNMmXvF0yc=;
        b=sp9lNPdKsumKTBZmM+27L4vqZwtqOjz9+wUgcnCN0+6lEQ9udTVKcPgmMqQ3cpnfsg
         zIJLi0wMT6Owy1T8XFUajiZzyvKT6NHPhcXwFA0UUI21fLwiO/er3eYZUpoPEDxffVwH
         G0KNE0/To/7Z/2DmL/u8lSu3nHtIaeoShIBFVgNv8aLTtN6ulkifWRoCUtNzxrECioGC
         5uSVwpDYqdknfQCB4MDjMKgke80ZipHe2R2NZAn8KdhRCw4cgC/WVHoG6JaTDfg1t/kj
         KPDNFVj76xA/YMa3xTU2lzz0oTPd9oG+ksw4Qa25WDgYMule0OPWBZTgZjO+fRipSZon
         CxMw==
X-Gm-Message-State: AOAM5303q0Lj9zLxTlXcagZ3i3y6D8BOkEIrVITv8Wfn1og4nzp69xV7
        WbWR5BZON7x3HET4FgprZl7m7Q==
X-Google-Smtp-Source: ABdhPJwR5k6COpqIu/RRBRupJZMcuya3aOjwRNFTRQkwFJHvEFeDIcg+W1mNgVdxhTeIc/v53THTBA==
X-Received: by 2002:a05:6602:2d4e:: with SMTP id d14mr2414322iow.105.1604595010463;
        Thu, 05 Nov 2020 08:50:10 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v15sm1487038ile.37.2020.11.05.08.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 08:50:10 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in io_uring_show_cred
To:     syzbot <syzbot+65731228192d0cafab77@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000003698a305b35e63fb@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3588ce0a-46cd-91dd-79eb-6ecc13496e53@kernel.dk>
Date:   Thu, 5 Nov 2020 09:50:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000003698a305b35e63fb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz dup: general protection fault in io_uring_show_cred
