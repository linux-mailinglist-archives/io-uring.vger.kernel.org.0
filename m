Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF83141FCA2
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 16:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhJBPAF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 11:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhJBPAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 11:00:05 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3755CC0613EC
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 07:58:19 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h20so13628145ilj.13
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 07:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VZYVmnI5MBZDfmRZmzTEwg1NpJAp6mNQqeweZmrcpqU=;
        b=8WypEfN1c7DqV9S44w8fXA04Ty72AqYDWC+jaj9+f3lw3bqAYf8xtxH1fklhgCRKg1
         eMsWGU/95fdE1MPcbwIxlXAMn1EEuQRPBr06d1pydnp9diwGSgE/JxeaduGNKZsDSpel
         CsxqDrO1OoE6WrpKFhKpXU8Wzlg4bQqv6Abmgkrqh5xnS5A81D8me6FKgkbnvD6hximW
         eqOyt45tg1aBUt+DhxupI55vFNf+CJH08X/WoIIAXUn1R/A5I5c0HcO2fKwP0QncyC99
         sKsJer+Iq5msHUk4Md3P/eiH1Ip7GwILCrqPnem3uM4HSH1hdpII4uWN7ibWV0RsCszk
         bqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZYVmnI5MBZDfmRZmzTEwg1NpJAp6mNQqeweZmrcpqU=;
        b=KPjS411FO+sZ8bLzyZiH5VINUSMM0nhIpukwz4mF8FmH0sffiomYsEnEvkTIgzo4KL
         rB0kZYFWzWNDhPwiPk8PAnj3hd+zc1itkiBPUV4ms3v0yUA98xuW+nVCHvhsNwyJ8ALB
         UIy/iWiB25KaSfh87TEQUhNS3n37AK/iw6nKZarCtZcp4oqgKmt3vvULrLYe8IabimAF
         y46uJl4yxL3UP19itUTKov9sLJnyM6s2DRJiZ3IU/du34fOl1Y2wc0UuONwzdcdKD4tc
         pbuVY+lqa8YkML/48ATm7KiSUuImscmDyoycchurTMfty8viYoSVNUVjFrXHmY1Eairp
         5RtQ==
X-Gm-Message-State: AOAM532yCJ44uz5MwAOHLTp9vqd91GuJ1lgWoa7+CjO3Z40WNMQXveqg
        1/gO4VgE3FIpUNCWZNCJj6SVUcTIlQjLJw==
X-Google-Smtp-Source: ABdhPJxcEpDvU0dlNnJiHc3eESg6ZjhJ2L0lDfVREwWcZ4hnpSwz+wSCybbQQdXFMpZtm8ES8JVMlQ==
X-Received: by 2002:a05:6e02:885:: with SMTP id z5mr2837888ils.273.1633186698213;
        Sat, 02 Oct 2021 07:58:18 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l3sm5653358ilq.48.2021.10.02.07.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 07:58:17 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: add flag to not fail link after timeout
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <52a381383c5ef08e20fa141ad21ee3e72aaa2857.1633120064.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <448c3b57-3c3a-37c6-5f58-b0a7ba51b497@kernel.dk>
Date:   Sat, 2 Oct 2021 08:58:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <52a381383c5ef08e20fa141ad21ee3e72aaa2857.1633120064.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/21 2:44 AM, Pavel Begunkov wrote:
> For some reason non-off IORING_OP_TIMEOUT always fails links, it's
> pretty inconvenient and unnecessary limits chaining after it to hard
> linking, which is far from ideal, e.g. doesn't pair well with timeout
> cancellation. Prevent it and treat -ETIME as success.

That seems like a sane addition, but I'm not a huge fan of the

#define IORING_TIMEOUT_DONT_FAIL	(1U << 5)

name, as it isn't very descriptive. Don't fail what? Maybe

#define IORING_TIMEOUT_ETIME_SUCCESS

instead? At least that tells the story of -ETIME being considered
success, hence not breaking a link.

-- 
Jens Axboe

