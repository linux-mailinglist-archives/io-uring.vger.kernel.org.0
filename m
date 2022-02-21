Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F394BE153
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 18:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380475AbiBUQeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 11:34:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380529AbiBUQeC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 11:34:02 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCAA21E1B
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 08:33:38 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id y11so9333969pfi.11
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 08:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1hCTFpnCzLuUDmQAPaFu3Al0s869BISW6EAQBZ7qqBQ=;
        b=ZHQBO7YRd+MwRstOGyPLZqm0n0FbXbOkUaPY4bB86b9QTu3EA2Ll+4jcO31UKwiWxR
         hCR9nr1ZMxHFrcLXqh0Wg9j5yKwccuFw4/MBPYbhESiQnW9VPoY3Rv78CYqgmgSDQc8+
         dpmInxs3O1Mo2iLLGUnJpDXOQw7ZMA6oKc4wJIupYYoheFkV2XXCZdglUKyQCyDROS5G
         8lNZEbg1rjd5HegyJ3J2CcP33AzMyzXY6Cm82ULQY/b6UPylHTLsOQTfNYv29RcLJgxH
         htJ/Zs5l7I0yF5VlvjEM3d/r62t/bdoaEHp4lBcTtThTaa2lZZvEkb+EtEXXXlrjmcKE
         Sd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1hCTFpnCzLuUDmQAPaFu3Al0s869BISW6EAQBZ7qqBQ=;
        b=pbs57exRxYd5dXBt4SlZPZ73Wu4ZhS3yGjRXXUtkCRAMuAIrME3wKLnt1s2ujEhcpU
         XBDwlE18SdBy4Yr4GVEd2Z+WJPNRE7oCkMEqDKXwmM5rGKzyc9Rh8f+gftfrNzodjJ9p
         kYctOCPw5NtksD9723XIPq3e6O+v3UJRQOeym2bYDE4avJLHKfFrSNCzGVbEueKWRBSS
         hA3VIBwJ2dwqDxpl91hiVFuNZWMHQCZdqR3Js3GODZ6JxGXg3wnCoRtgidxxek/wsSSB
         Hom1KWUe+HPe8C7mnkpZBMbYez9g3taPGrZ8BKkVWWDS2Sh2eAHLwCVSlnJA9invERbV
         zzKw==
X-Gm-Message-State: AOAM531BlQdUcy1dz5VMbZmayE528MMqG5a2nwNMxQhmT336XsNa4nZp
        0N3SeQTJOOkRG4Eq8QeXfebllg==
X-Google-Smtp-Source: ABdhPJzp9N1FQggNes9vJSVICTbf/PbgO4928ZkIXYTXVCSkurWSwOBFEmdqwABEWlnOll4YOrbqiQ==
X-Received: by 2002:a65:6255:0:b0:364:4513:67bf with SMTP id q21-20020a656255000000b00364451367bfmr16699877pgv.64.1645461217587;
        Mon, 21 Feb 2022 08:33:37 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v3-20020a17090abb8300b001bc0740c35dsm7192931pjr.18.2022.02.21.08.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 08:33:37 -0800 (PST)
Message-ID: <f8f591d7-09c8-c537-ea41-30e0b33e29a3@kernel.dk>
Date:   Mon, 21 Feb 2022 09:33:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 0/4] io_uring: consistent behaviour with linked
 read/write
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20220221141649.624233-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220221141649.624233-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/22 7:16 AM, Dylan Yudaken wrote:
> Currently submitting multiple read/write for one file with offset = -1 will
> not behave as if calling read(2)/write(2) multiple times. The offset may be
> pinned to the same value for each submission (for example if they are
> punted to the async worker) and so each read/write will have the same
> offset.
> 
> This patch series fixes this.
> 
> Patch 1,3 cleans up the code a bit
> 
> Patch 2 grabs the file position at execution time, rather than when the job
> is queued to be run which fixes inconsistincies when jobs are run asynchronously.
> 
> Patch 4 increments the file's f_pos when reading it, which fixes
> inconsistincies with concurrent runs. 
> 
> A test for this will be submitted to liburing separately.

Looks good to me, but the patch 2 change will bubble through to patch 3
and 4 as well. Care to respin a v3?

-- 
Jens Axboe

