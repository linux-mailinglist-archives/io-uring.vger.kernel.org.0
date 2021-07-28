Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2863D90BA
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhG1OdV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 10:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbhG1OdV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 10:33:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F12C061757
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 07:33:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d1so2957737pll.1
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I93ZekgMt+FP/zMznbmK/3Xm03pBLCP/or32y9OnTwk=;
        b=GGaOGy7FfumLwM4TAILDi6WxWNaFmAyvqipqbl3Yj1vbbB07Zyfu33eSzCFA4RG8+g
         u18POYYJ0/i0WRKPKkjwhLckqQLLeZbJisW9Exm4QHDVCcIWtFlmqyNkJ4Eqz4+zEdNU
         PVfXVpZAC4k8yYKf7K0r8LLpLr/QM8ZOWH9c8Tgc4pZldX611WxG4cl6oCLlJ5jzzwoo
         sI22FN8h4802zo2viAQ09EeNJ418sRnCS/DjXdAkEVfrybgGFbhsI5/6w7RuWn4WI2HO
         j8I0Z4DLgBUWV6Ulj+DQ1iTkFevqn8RsFANYQpyOrfTCseXxjh56kgeCTPheOl3Bu7Uj
         1kBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I93ZekgMt+FP/zMznbmK/3Xm03pBLCP/or32y9OnTwk=;
        b=DHGHwqSc5MSpdyqeGP56dF7UCPmIdxLVk0B8DiG5lrtTTKQb1TRqnQlfxf/hgbq/+c
         9+E210s/QwzmO30wAN8s+w9ItaS6ArmJXj7J78pgbV6guniblG4Jk0fEpSBv8A7agmd1
         086wbby8ltCHQQQtYtbXCkiGYbjTstSfS0dJadFkodGlhymCgLD1Q5tAr12M4Kznropt
         +invGKjMbYKKK+a8pU69DU2miVxvCWzAI8ZLqURq5ZVGpDUIy/hpzG5cl6FU4pplL7JM
         3UR4Mq/N9hJsHXpyxMvkx1XuLniuvByolWaQfDDv8CxRrjTirAToCymZ8+BheHMMqnXj
         6ABw==
X-Gm-Message-State: AOAM531blyCXb1+vCZSrC8MTWL7K0aRvShsrc2VCNhnDyyE07KiqTUKr
        2edQZtGLHGTEFwOSbrMcd3/n1w==
X-Google-Smtp-Source: ABdhPJzBw/wBCVO4Dsy6MN0pXP2d5QH1eVpLyOjzoiOZSbNoCft+95kz7fSV+VOJfTM4w9WvwKKz4A==
X-Received: by 2002:aa7:8148:0:b029:31b:10b4:f391 with SMTP id d8-20020aa781480000b029031b10b4f391mr74374pfn.69.1627482798955;
        Wed, 28 Jul 2021 07:33:18 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id i6sm184919pfa.44.2021.07.28.07.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 07:33:18 -0700 (PDT)
Subject: Re: [PATCH v3] io_uring: fix poll requests leaking second poll
 entries
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210728030322.12307-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9183c6f1-9430-d55f-803b-71d5f71d2e41@kernel.dk>
Date:   Wed, 28 Jul 2021 08:33:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210728030322.12307-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/21 9:03 PM, Hao Xu wrote:
> For pure poll requests, it doesn't remove the second poll wait entry
> when it's done, neither after vfs_poll() or in the poll completion
> handler. We should remove the second poll wait entry.
> And we use io_poll_remove_double() rather than io_poll_remove_waitqs()
> since the latter has some redundant logic.

Applied, thanks.

-- 
Jens Axboe

