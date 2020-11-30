Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4312C91AE
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 23:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388680AbgK3Wyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 17:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388679AbgK3Wyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 17:54:41 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077B1C0613CF
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 14:54:01 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l11so7361310plt.1
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 14:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IPZx/F4zp1yHH3yZSq9B61a+dH4K9EAbUAgO9LeeNIU=;
        b=jGtKk40E5VtOF1fgF9KnSqEH7JaU4pINdX42r4jXy7q5anwV4x4yVlYFefSXJKF6NW
         4g8WFlSUlGF6FSQ536+kxtVHm+mRVGWBm+E0Rn3KmFEh70lM05w3DIQmV1T8IHaRZXK2
         1ngMyd0JZ0Rf4eZ3PJJYZ36j8x+f4r+f74Za1TNkyVIm8l4M312q7MngQrvxIzz2VK4K
         x6+LkpzmV8PUiUPXqSWiKmgKXjy2LOJF56a+qgrQTJIglyemx8jYoh2+3n5DPj8Oq2E2
         MBsgHD6FAWCcJq6nTtp/sZB3yLaK+sqbrl0XYx8AWFWoxxotqpGH4ecpn6Kp/53HHThc
         3+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IPZx/F4zp1yHH3yZSq9B61a+dH4K9EAbUAgO9LeeNIU=;
        b=J3Y2tdaF/o5gx6lHhZ9p8ijqhsMltrO4wWZtIoSjZNpDWiMgKlF6Y5QiDlyA2VANDO
         6Bq599bBfatPD7AWexOZot4wIrR0ErtkvR8aOu1HkzT3TH+4vzqabGOaSk5Vs7003gX/
         ETxh9HXKcbbwz2c7ljT1ZW5rQuf9HJWUmgO87W87VsPji1bTnUHfgJiJGxiVWXjx/eMZ
         rb4GWLJFoEtngrjjDYMZTsMcCiib9I9bt3QyTwuHQAQhisaMolkWpEI7FnJUguAQCbdA
         N/AGfME9KYKjb++zNwICMW++lOyZ/YuV080+6p/RORiJGBfM5gvw+2my0n1ZzvdJT9ya
         kSQA==
X-Gm-Message-State: AOAM533DwXHybyo6NmeOQAyeASSypHAbcB0mTE9BWBJ9RKEWn3eMhc0G
        FR2EHBBHTFTGs2pGs0Hi9tqLbHW/fMbhwA==
X-Google-Smtp-Source: ABdhPJwdhiWtKNzTVLvBzhURjWkFH0aLFmAXMVnhnLfuPpLmQewDyHF7oYNqBeXfzIU5ctOtAwsI1A==
X-Received: by 2002:a17:902:7b97:b029:d8:e703:1367 with SMTP id w23-20020a1709027b97b02900d8e7031367mr50837pll.11.1606776840367;
        Mon, 30 Nov 2020 14:54:00 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s5sm37907pju.9.2020.11.30.14.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 14:53:59 -0800 (PST)
Subject: Re: [PATCH v2 0/2] implement timeout update
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1606763415.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <040eb01f-37cf-3db1-9090-0ce99d65527c@kernel.dk>
Date:   Mon, 30 Nov 2020 15:53:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1606763415.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/30/20 12:11 PM, Pavel Begunkov wrote:
> Timeout update is a IORING_OP_TIMEOUT_REMOVE request with timeout_flags
> containing a new IORING_TIMEOUT_UPDATE flag. Even though naming may be
> confusing, but update and remove are very similar both code and
> functionality wise, so doesn't seem necessary to add a new opcode.
> 
> Updates don't support offsets, but I don't see a need either. Can
> be implemented in the future by passing it in sqe->len.

Applied, thanks.

-- 
Jens Axboe

