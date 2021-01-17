Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EEB2F9060
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 05:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbhAQEEz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 23:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbhAQEEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 23:04:54 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCAAC061757
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 20:04:13 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id m6so8132673pfm.6
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 20:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8qgKDAUlLlJPN3kc7yi6ltD0I9qANocNqwvytGm0oxY=;
        b=ygubPUmPX+u/fEh+vOO112eQy2pst5+aDIfSWyoPT9sdUh9DE+hPoDyb+8gIT+zYJj
         CP7TJHXBKpEKhPsvv8Q+AZDNpMz8Lt4t8NzIo+TeGg2Fwc8bgsSJMbSAmTFtbMCwMmyO
         4w40d+eh9V3eJyHk8WLrSXMsTsOz7VDfrnfP1kAfDPM9SeTe9J4CA1GGUbPErJGXsSr6
         WQbEjUykEdBtQvJYJIo4cvIn/QfFuVm29ClanAXEWlgTasdIv3D7ON2d8W4pi+uvYiuz
         AtWAVhHqWiHyWhZqHu+TH/ewtwD8GHqiFXAXEAeIoVnMtKqfnljXdvfH6UyUU6ZGmd0T
         mjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8qgKDAUlLlJPN3kc7yi6ltD0I9qANocNqwvytGm0oxY=;
        b=ZIvDSZBjzS6faFNK8tFgON1TZHeLV9M4nb1lilL0AiH+s2IBgWxj/+9NN7grYCBFI8
         aCYoOKhNVpbp93E+rJLh2ghp1gtTSqp91zH9CTEdp8dX6dgCQB6aRIBcQsMqWoQmryfq
         SeuHHfXXy6sSJI9yk7Vi+jQaeyB1Q1BqKbQOuhX9L1/AgrbtUMkGgRN4Qaxka7LTVcI3
         NWa17BfCzGO3CDgxNBQH7OMW3N5MK1j+asS5+S2LBRVGx9DqQ3S+KV9QP2Cq/u9Vdk47
         tcwdQAVTpGusFyGLFPrv5jlRW5NBgkz2y2AogSOVLJkkII0MSdA2SeLgZkALRUmRITjS
         BMCg==
X-Gm-Message-State: AOAM533ArSTGXydrxToo9iXu9qEk2pPC4K8S/oCt9ZL1KWjk+Pr3vxGi
        TRNdYfSE23UDdcs5Qu0Ycpp0c+VpMVPLkg==
X-Google-Smtp-Source: ABdhPJzNhDYlAoSdAFirQOgJMahW/xbeYPL6InY2f6RegAv/lnnHBuJaT+U8q/3y2yep9lYKIBgL0g==
X-Received: by 2002:aa7:8a99:0:b029:1a6:c8b8:1414 with SMTP id a25-20020aa78a990000b02901a6c8b81414mr19970930pfc.66.1610856253060;
        Sat, 16 Jan 2021 20:04:13 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 22sm11843378pjw.19.2021.01.16.20.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 20:04:12 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: fix skipping disabling sqo on exec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <aafb4f9c5380abad2142d33f4969ae5ac32f2c31.1610850562.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ca2bd29-4d61-8246-b3dd-661f77be165b@kernel.dk>
Date:   Sat, 16 Jan 2021 21:04:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aafb4f9c5380abad2142d33f4969ae5ac32f2c31.1610850562.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/21 7:29 PM, Pavel Begunkov wrote:
> If there are no requests at the time __io_uring_task_cancel() is called,
> tctx_inflight() returns zero and and it terminates not getting a chance
> to go through __io_uring_files_cancel() and do
> io_disable_sqo_submit(). And we absolutely want them disabled by the
> time cancellation ends.

Thanks, that looks much better! Applied.

-- 
Jens Axboe

