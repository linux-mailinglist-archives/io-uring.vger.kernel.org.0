Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0933E4B20
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhHIRsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 13:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhHIRsY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 13:48:24 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8B5C061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 10:48:04 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d10-20020a9d4f0a0000b02904f51c5004e3so14520504otl.9
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 10:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=A2px95SMcesFIY3yH8Hkh1h35ItkPNv43iTt1aYmQXU=;
        b=REKME+3+QDPTBCa3EVx69OLrFPYaUIAiVj5nJT1pCttvnIbY12ZEMyZ1oSfmcqYVso
         HZGTh/sBkNOcdwMPJkuw3gx0q2QsAXLz+WtsdRiekZF+sS0mc5lfAYG+5S6v2xxS4QOj
         VAqE0Tkm8BGcGBAw1W7hBFgxUk0z35fcqQXd0Ho9uBKfQ2jaU3Res5O0D3IYaOZal3jG
         xjYpIstjvobZCgLYKe3WZDYqAY4rC3uvGU83HP4h957VCULuOjHT0IUD4266yv2wF72I
         h6QoKPkmE7O3TL5+KP3feRsp28RUfuS/VJ7kAgwddgeP4XB235KLSKW/CugxjWSu7t0h
         H9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A2px95SMcesFIY3yH8Hkh1h35ItkPNv43iTt1aYmQXU=;
        b=VEpRYjjrTTVEdGofEMJ1iZkOqripauKmGRvjWFpDcQFioIx8FOipLlOlIKV/daGCAy
         hDOws5ETbNg29q8wOI02o/3MZkwd9v7v8goIJhUDrdRqkfpBsaYY014NKwtKRjdrxpDp
         Qc+IAnIEHgTNko64+FBBh+QqDsmT2V3NBikyLtHlTKdyRiIeJyax3HXqM2wg072SR0hG
         t8iN0m3Fq8t3izC2H0KJqsqd0iH+w6t8onQT0esUmZINe07HyLO6ehlh0hLWO/dSJmOF
         NUtn34T43oVuqZQOVhPX1+lUWmmA2b8kdGqrVVlZaBrMSd2TjV/ykEPQT4kHaxpd24gc
         8Pvw==
X-Gm-Message-State: AOAM533HMW+TmIin9/2gF39TmfLrHMgdzfq85LxuJFgmpEBw9FKu/fQc
        d+j4oJUECryAJMic5N++kj9v79eXbrAG9S4/
X-Google-Smtp-Source: ABdhPJwjFltayVHAA4mm80Qvbbdypiq5kwZB+TkoaA93VK5zXNOZPQsrMXGl7tEuu7r1zCTCZJihfg==
X-Received: by 2002:a05:6830:245c:: with SMTP id x28mr14275791otr.227.1628531283226;
        Mon, 09 Aug 2021 10:48:03 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d7sm2856148oon.18.2021.08.09.10.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 10:48:02 -0700 (PDT)
Subject: Re: [PATCH v2 00/28] for-next patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628471125.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2175a9ff-68de-e9a7-ddae-fe232c11fe66@kernel.dk>
Date:   Mon, 9 Aug 2021 11:48:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 6:04 AM, Pavel Begunkov wrote:
> 1,2 -- optimisation with kvmalloc()'ing file tables
> 4 -- optimise prep_rw() still touching inode with !REG fixed files
> 11 -- a small CQ waiting optimisation
> 20 -- put_task optimisation, saves atomics in many cases
> 23 -- helps req alloc sustainability, also needed for futures features
> 
> All others are cleanups, where 6-28 are resends.

Applied 1-20, stopped at 21 as that needs a re-spin.

-- 
Jens Axboe

