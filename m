Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A206F33FB6F
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCQWo1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhCQWoT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:44:19 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D15C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:44:19 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id m6so3083996ilh.6
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=siaR9uumTDJAaj1fA/Tjif68M9VcO1oXOOndpF08G1A=;
        b=bG3TFpRjw7ulIg2HDPwSI7FQ8tgy6RH8OsjXROS1iWEdJG6F/qkg23PUakupKRtNBH
         5Fflc1dwwjZYjaHgU/xnBUyyzkIcxIFpUWRIhi8wdl8cI2GDIUnfiybuq3Ht2uOow6rr
         JRHWAamdCRFPiVvng8uxkMMFS5q3tU/7IM3RWabAerHe82teMVk917qDt5a7aCYEoqDL
         GxUdc8Jf1kNeP8KWgb0w6gSV2/c0aPryP/Wc0thzsPinYZY0teVUHRAwAf1yNFw0V9Jo
         WaRMa+/BPbb4HYh8aNNGDhyVT8MivBpOew+/l5oL9rEVY2IT8d0CZ9GzA9hjQhoROmcp
         qKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siaR9uumTDJAaj1fA/Tjif68M9VcO1oXOOndpF08G1A=;
        b=cWC9S7UoR6GQ4G1tGpzIwYWMaFOY46bP9StudwL1MariXLUXahCH18Yj/CSMxb7OgH
         M+AH2BYpVgBMrFiw+WKDgW8nv72A99uOZZOuCMGE479368b6nfCc8T5blBUS2swWBnsD
         SBalhixLrl2LYpq47F/NOXF86V8XnmZeAz7BBwVKGH4mQgGc4mNk4eR8PvPH5CdLqn5i
         NtIJyhiSM3lYW3RfWhM4Xq3XKfY1nH8Wpr5NyifB3dnAaUW72ZoXVZXJ8rWVq0a8O2dx
         ZTJrn3LMI7jCwMffTlfrSimQhomp1u3IGvUs/dPmC6jW5hy4HxMyugU7H+GFDWBQ2srM
         0NSQ==
X-Gm-Message-State: AOAM530asshhMMF9nvPt+lvYxlAD1kk8xWdjoVPDbB0k57duBkwYvZKJ
        NC1HBZPASrxqEEAmOv4hmux/NDQ5uME+KQ==
X-Google-Smtp-Source: ABdhPJyNbqt7NM8hSnDCYmihoKgXqZa9RS7mMbfsoFy6GkrwQljy6e2/Cfn8Lh8GzNXolyhZObkj5A==
X-Received: by 2002:a92:da48:: with SMTP id p8mr8769063ilq.137.1616021058699;
        Wed, 17 Mar 2021 15:44:18 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r15sm191639iot.5.2021.03.17.15.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:44:18 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: remove structures from
 include/linux/io_uring.h
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1615719251.git.metze@samba.org>
 <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
 <5c692b22-9042-14b4-1466-e4a209f15a7b@gmail.com>
 <44a742f9-4631-7dc5-48f3-1d07b1334c86@samba.org>
 <1d57b68c-8033-7816-4b42-e19f3cc6efee@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5c9e3a75-b74d-9cf2-1f87-bb24fe5fc71f@kernel.dk>
Date:   Wed, 17 Mar 2021 16:44:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d57b68c-8033-7816-4b42-e19f3cc6efee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/21 5:02 AM, Pavel Begunkov wrote:
> On 14/03/2021 17:14, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>> Both patches are really nice. However, 1/2 doesn't apply
>>> and looks it needs small stylistic changes, see nits below
>>
>> It seems the mails got corrupted, I played with git imap-send... :-(
>>
>> Here a branch with the patches:
>> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-5.12
>>
>> Should I resend them once I fixed my mail setup?
> Who knows. Jens, do you want to take it for 5.12?
> 
> I just recently converted tctx->last from file* to ctx* and had to
> gaze enough to not screw, in this light 2/2 looks good from the
> safety perspective.

Let's do them for 5.12 - Stefan, can you resend please?

-- 
Jens Axboe

