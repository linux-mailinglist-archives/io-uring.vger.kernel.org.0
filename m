Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C6535038F
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhCaPgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 11:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhCaPgc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 11:36:32 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AC8C061574
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 08:36:32 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z3so20533317ioc.8
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 08:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tFcF2XGF9886Hfo2frvuFRpvt7/n4PVeMEFLmyEuHk0=;
        b=au3J1n5lv3JhOoL7QpbmK2Mn8i+pls7nDcMwk0Kc7jc++EnFM+QEE9/BrcAEHwNoec
         hddUONZ3ewL1fE45phyds0EHlfdZNJXK4ejXow0j1uEAQEZz3EyMwKOMwTTiyatpHY+d
         j45RnAEODQ8Wes2sVrYuutpXHmWKkQ20Q4coeIB+FBn7DU7WtX4NH6ZYs/KCHuzFc9oe
         m3gVepjJ7dCWSIQP6FlZQv+qYnYkUp482IGnn5SglohA+7D3uG79wWDogL0ndg/kkeHw
         tM5RHUrIBg50c7xzS5hyx/oDC9qRlpB4JNJSlRsXk2rKwf8i5tHXcrbfqc1svYc51jUF
         EWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tFcF2XGF9886Hfo2frvuFRpvt7/n4PVeMEFLmyEuHk0=;
        b=Fs11Y8imgjMfTXXTTH4FNvfitNbPSBSEaiRPKPDexzKWEncPcrEVCie2XGa+v0ZUBz
         7AipPFtXp+aQYjom/oBUKs6+WfVrjogBUibLmm+jx2Ud7RrgrZLNQr6QFYiMuKlZ5qdF
         wo6V4tDG+MI+h2RNW5hjdj++3BzwdBWFy58rNwEKT0cYBnlzVDTPFQFgO+XQrYKMpeEu
         S48GSiKebeUTna14RKycH6fMNOo+A6Yv8S7s+yZYqB7mbfA7JWKjzLUI/fS87byy7ovl
         CQVkOHJLS+nNOnl5r/nYE0HaF8z38hzsHQ8hIWPxwYWJe3OyAy+2lQylMhv/V9+S4+0v
         aThA==
X-Gm-Message-State: AOAM532WZJkeOd+pO6Tyma6i37gxOfrk58gpVh4OAI1rhrsCGMLQxr4i
        Gp/VRpfZ3LGdAZzlq6g9zOPC+qAVhO1PcQ==
X-Google-Smtp-Source: ABdhPJytAez4fMgfbVDa5lnlCJYf26v/B1IvkClo2Dt/NkpiJa9rdb10Fmvck/dwTLAgI6ImE4D0JA==
X-Received: by 2002:a05:6638:d47:: with SMTP id d7mr3584299jak.2.1617204991478;
        Wed, 31 Mar 2021 08:36:31 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l1sm1147977ilv.34.2021.03.31.08.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 08:36:31 -0700 (PDT)
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3a5582b-7704-9bf5-f78b-23b0fe73e721@kernel.dk>
Date:   Wed, 31 Mar 2021 09:36:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/21 3:01 AM, Hao Xu wrote:
> Now that we have multishot poll requests, one sqe can emit multiple
> cqes. given below example:
>     sqe0(multishot poll)-->sqe1-->sqe2(drain req)
> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
> is a multishot poll request, sqe2 may be issued after sqe0's event
> triggered twice before sqe1 completed. This isn't what users leverage
> drain requests for.
> Here a simple solution is to ignore all multishot poll cqes, which means
> drain requests  won't wait those request to be done.

Good point, we need to do something here... Looks simple enough to me,
though I'd probably prefer if we rename 'multishot_cqes' to
'persistent_sqes' or something like that. It's likely not the last
user of having 1:M mappings between sqe and cqe, so might as well
try and name it a bit more appropriately.

-- 
Jens Axboe

