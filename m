Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921F033297D
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 16:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhCIPBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 10:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhCIPBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 10:01:04 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A6DC06174A
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 07:01:03 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id g9so12433995ilc.3
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 07:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BOw8i5QB9HP/HGQSgum1G2lk8HYOGO0pN+CBwWNIyW0=;
        b=DZYBwidp+Oc8d2WSQmWg5UL0PE0LlIeG+dqrTSpYZHyqz9qmDBZc3JqpcrVFZ08tsn
         uyqMp96jZkqexKnpiuwc0S1uDbL7kiVHomnxQoNKhWzDSbh5odSaKUE99S1wAE7o7j65
         9zVcC7za+sSRwBaHwECztu93FOHGzlLzy6KD4Ss9Fjqln7jVmOcOvtOLggSF1DdiIvDi
         xOLFIhqmrGc8ES5V5Qnao9/fl1mpBqc0jTkySAO4p1g7YK8ogvSOXNzQhqIliKJfWvz9
         QdfSwjJbfSLf9RuWGcokKCiiXnZmNlul36bhPbRf2D0Nr6sONKV0BYHjB7KgV45TCG8F
         eT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BOw8i5QB9HP/HGQSgum1G2lk8HYOGO0pN+CBwWNIyW0=;
        b=Vj86DMcjxy3fAif5uOncBUMSFHpPiP/mb901XvLy+D9buPyCaiJhATiQbwTB6LbANp
         JzIM09AiQD9BtoB8Zi++IZl9phUXN03aKdRtxnWgMiRVSpk7P5L8g9qjt9RfiFfpPgax
         UfEYonD3rfhqi6sGmco1Zcw1DGVmtsX72aFp6vH7p9eY/fECL1+kOAzo+qLA9R6Jnoyt
         Ql48LijaeFivljSI/aiJL5Kl8XzmaclNiXj5UQQ9LBV60C3xffX6UF5H4uwcWZvJjCut
         rXi7I3DgdC5tErNQCuiLLoTBwf7IWzYpiNl/agfVgdSzb8LvGVAcBHrM2r1sry1YhkDM
         5+pA==
X-Gm-Message-State: AOAM5334PEgC57jOAxlkKKqAUmD3g8+nn29aXeuTRVLufawldf/Z/LH/
        732Ov7ySid2zAvUGBRPO6twy/iAkNV91IA==
X-Google-Smtp-Source: ABdhPJzNMpTBDnErQ8aqoH1EJt41ZLazTnSOFSBl4kwyz8QUeRkzfedVDilzhJ8QNmrBRQ+r98Yviw==
X-Received: by 2002:a92:b70c:: with SMTP id k12mr26152449ili.60.1615302063162;
        Tue, 09 Mar 2021 07:01:03 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i67sm7785521ioa.3.2021.03.09.07.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 07:01:02 -0800 (PST)
Subject: Re: [PATCH 0/2] io_req_complete_post() fix
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615250156.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <81ae0ee6-4a06-46d6-2ff1-4f2962f914b9@kernel.dk>
Date:   Tue, 9 Mar 2021 08:01:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615250156.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 5:37 PM, Pavel Begunkov wrote:
> May use more gazing by someone to avoid obvious/stupid mistakes
> 
> Pavel Begunkov (2):
>   io_uring: add io_disarm_next() helper
>   io_uring: fix complete_post races for linked req
> 
>  fs/io_uring.c | 89 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 49 insertions(+), 40 deletions(-)

I looked through it and it looks good to me.

-- 
Jens Axboe

