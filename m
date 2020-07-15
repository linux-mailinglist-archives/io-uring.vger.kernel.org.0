Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C8F22152F
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 21:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOTgP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 15:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgGOTgP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 15:36:15 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFD4C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 12:36:15 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t27so3008708ill.9
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 12:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d7AfGI/VHV5A9wAPKrzWCZjeMpIAuplpLcwj7EoPaLY=;
        b=rk3ARGDenVhrL393N64C8+bBUIXTvY5qrXRK4yq7QGIIW2tw35S1opccWXEuX/fRz2
         Vk+mZJXHROUe1R7hjfEOael35ptMC/KRbzEcsH8TKoI3BlsE5pMm63z16oVzNN3Lug7l
         g6qEmqt+oBUw5KxURhWTjT/Anvp/cItj4Smmv8UPQLUn6IhSGsr+EAItldHulfqGUeNs
         sN+1rseOjJg/1aeEeH44TLSUng2us5V9AlJ5hCwUSGjJ6fSDUp+dxBs9I1zCT5jxCSzZ
         luBb+q6vOQ9giymIhEOxoyND2+zsP70aw2qxCmkjdDtcemk7cAPt8OiEboE8UldT3hpV
         sX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d7AfGI/VHV5A9wAPKrzWCZjeMpIAuplpLcwj7EoPaLY=;
        b=ZutYF7GPxJZHACCEYxedC6kKZVNhmpZi1BSvw1eskc0Egbq21bENbVv60JrAvW9wsK
         GFfDBptZUOlAWXzCZjpZLmyOpkTQy7KoAksbsacrNZAF6Qyy22m4YE1kCEABW5IKu8Rt
         ws968D7sZD712x+dxz0R6CkNhMkz8Zp98tAVJENOF90VMiUL3Y/9BDuL4pdH7iPsd9RQ
         NixtHmVm0IFRVs9QJICsC2zIdAXG/6BwQPF/EJ/Fw9WXapHlDDQsy2ZCwi2GVkEpISl4
         jB0XNN0Bzx50VsiQLfsCat7FfQsNVNYNf+nbhlWJH7qaT6lMBkIEMFw5gQuQOQ1HGiXJ
         eb+g==
X-Gm-Message-State: AOAM533o9ACNqSEfvgma84SYXdB/RjXICYj4nENmYZFMmnCmh9E2OnDe
        mUfIgnyfsx3EvxEt97vRqU/tCWGcrqH22A==
X-Google-Smtp-Source: ABdhPJwepH6mWclIa7UPKTjxASz0ZZD3x4nU2HboSAP/HvDipIXINHyLyu4OQZvKu3g/nHJ9RQyTIw==
X-Received: by 2002:a92:9f5c:: with SMTP id u89mr1084883ili.262.1594841774149;
        Wed, 15 Jul 2020 12:36:14 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x71sm1519237ilk.43.2020.07.15.12.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 12:36:13 -0700 (PDT)
Subject: Re: [PATCH 5.8] io_uring: fix recvmsg selected buf leak
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <5b7c61cc77e0b85a4cfecf768be1c3982eb8ae05.1594840376.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b671c64e-71ea-dce6-b442-7a9f1f32cbba@kernel.dk>
Date:   Wed, 15 Jul 2020 13:36:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5b7c61cc77e0b85a4cfecf768be1c3982eb8ae05.1594840376.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/20 1:20 PM, Pavel Begunkov wrote:
> io_recvmsg() doesn't free memory allocated for struct io_buffer.
> Fix it.

Thanks, applied.

-- 
Jens Axboe

