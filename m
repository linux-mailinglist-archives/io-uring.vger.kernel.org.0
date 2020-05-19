Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4781DA44D
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgESWMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 18:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgESWMY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 18:12:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F96CC061A0F
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:12:24 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v63so534980pfb.10
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DJ4BygB5peVgcFI85pUN4LwLz096RnT5vt6WinaWaks=;
        b=S367gdO3t/rL54QDf1IBdCjXt/ZuDMT342n4oguHVfLC1jvd2/oqiY+jMrntSO+a6C
         b0OiAO103aqSPG0kMYopW9VnUiBPqSoNvSm43QDmF9YIs3wTwDh2G19ztEszgpyyN1tq
         ePxm2Hao+Mym1TPgjt6Lt3nqChNmlB0oCJ1ditQf9luEjtm8H4hI/0C5CUYR6TZtFrKE
         YQHaAf3AXHFbdcvPVVhj3xviPyLmTf13EvAxXeqQaW6zf0plKTkaqmcMv64GEH7ZT0EO
         ZJMSnZnPG/dXjtB5O1JPIpV3IVEboLAe4GP9VrtCMcy22BRn2ESOw//aICJibYyl92u+
         hlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJ4BygB5peVgcFI85pUN4LwLz096RnT5vt6WinaWaks=;
        b=aYWxtALp0z7a0tWFwdoGGuHMJ6Xx/keDbnXlr2FgdQg0T9XwcLbyuadaStwqPyb4kc
         6H+oalWFcxn3PkM9fpevFOoFK10JfMiZapj9yIU/ztTtC8aMrct4Og/ucHVM0wo6Lk0/
         5wooTsxPWiGAY3WASo3M2QrEhwjlw2dn5JzWpk7BV1dwSuWp40Fi+GnbETVgQ9LbcwO4
         hQ5F7lAuGVpTGZDCNXqUfo7eOcWabqjF+nxcep4K8pxUWS6GfZCtkYZpdWtvTO2atKcD
         4f2n9cAJr9U2l4zdvIKvFgWV1dCGy+os4SoJLPkv06ODmRH/iGO8OiIi1p+QrXWQFsIe
         fcDQ==
X-Gm-Message-State: AOAM533lj0f2EixpsimITIiHpQjmmWfQt+nZKNVGSvmLLXMdtd5e94bE
        oNiVz7Cd3AiXjUrvCN/HwcZ6UsRws00=
X-Google-Smtp-Source: ABdhPJyawujmpmxD41ahOvuiMMkp0scxvOv+E3fHRVUJTEWFzPt6gGG5J/2hpaTsNUik9xA7RldNkg==
X-Received: by 2002:a62:7d91:: with SMTP id y139mr1204489pfc.172.1589926343434;
        Tue, 19 May 2020 15:12:23 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:14f4:acbd:a5d0:25ca? ([2605:e000:100e:8c61:14f4:acbd:a5d0:25ca])
        by smtp.gmail.com with ESMTPSA id m12sm408533pjs.41.2020.05.19.15.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 15:12:22 -0700 (PDT)
Subject: Re: [PATCH liburing 0/3] __io_uring_get_cqe() fix/optimization
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6df5d0b-af60-6914-ab97-573d4e6306a4@kernel.dk>
Date:   Tue, 19 May 2020 16:12:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/20 3:52 PM, Bijan Mottahedeh wrote:
> This patch set and a corresponding kernel patch set are fixes and
> optimizations resulting from running unit test 500f9fbadef8-test.
> 
> - Patch 1 is a fix to the test hanging when it runs on a non-mq queue.
> 
> The patch preserves the value of wait_nr if SETUP_IOPOLL is set
> since otherwise __sys_io_uring_enter() could never be called
> __io_uring_peek_cqe() could never find new completions.
> 
> With this patch applied, two problems were hit in the kernel as described
> in the kernel patch set, which caused 500f9fbadef8-test to fail and
> to hang.  With all three patches, 500f9fbadef8-test either passes
> successfully or skips the test gracefully with the following message:
> 
> Polling not supported in current dir, test skipped
> 
> - Patch 2 is an optimization for io_uring_enter() system calls.
> 
> If we want to wait for completions (wait_nr > 0), account for the
> completion we might fetch with __io_uring_peek_cqe().  For example,
> with wait_nr=1 and submit=0, there is no need to call io_uring_enter()
> if the peek call finds a completion.
> 
> Below are the perf results for 500f9fbadef8-test without/with the fix:
> 
> perf stat -e syscalls:sys_enter_io_uring_enter 500f9fbadef8-test
> 
> 12,289     syscalls:sys_enter_io_uring_enter
> 8,193      syscalls:sys_enter_io_uring_enter
> 
> - Patch 3 is a cleanup with no functional changes.
> 
> Since we always have
> 
> io_uring_wait_cqe_nr()
> -> __io_uring_get_cqe()
>    -> __io_uring_peek_cqe()
> 
> remove the direct call from io_uring_wait_cqe_nr() to __io_uring_peek_cqe().
> 
> After the removal, __io_uring_peek_cqe() is called only from
> __io_uring_get_cqe() so move the two routines together(). Without the
> move, compilation fails with a 'defined but not used' error.

LGTM, thanks! I've applied them.

-- 
Jens Axboe

