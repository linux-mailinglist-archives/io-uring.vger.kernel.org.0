Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A925EB34
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 00:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIEWEK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 18:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728563AbgIEWEG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 18:04:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AD0C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 15:04:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b124so6538310pfg.13
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 15:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SRYBSyqwuMPa0rl4uQ/wYuOKLXX3c/OgXi2EC6SKtfo=;
        b=OUXfJ5L2131Hz7Z/LWGiIiGOGf/kMzM5gttq73ZiRcT70IYUv3lx+e1Dyn/8nWCROi
         eXgbCRee5OM4B8nNrnQLr2zIDrHly9DInECb1/ehIicecqAT8f1f7NSIyJb79RpHigiO
         2AAtUnrPHt4CRo4IzDZogq9xUR6de2dvEG3rrMU1bHmChBntHP7Xo9hz9FoCK+Jj+2oV
         bO59CTXkGLhMHtSUThTPz/tYTvDZyAoSxgac3xiUUC5JeDJoRDYw/TxoyVlDePQTpzNL
         XyoPRYpxzP4Y4HnmIG7XVj4rchkO+bYRDQYPsGsIYoth1IqStHCoZRdhw7edFwLwyYzN
         UJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SRYBSyqwuMPa0rl4uQ/wYuOKLXX3c/OgXi2EC6SKtfo=;
        b=uCz5U11cpuzQtQfv8IQq202z8hb+jzcHi8SnTBodSrzf0z9ObujIW7Q2IlSr/bbO8S
         sjxaPiD+XSyhgASbtQ8HGjHfUFnfVO+RYOXfpWPjO6TqMrms9Urz+IO5dPKkvQi2/dpQ
         jRVv0SfBs4ptNFON+3P8D69dJ0kjs2jIWdGCACIn+G/Nx6kE4rPvLCoObwhAiPFkwndO
         Vw4O04yROdB8Kij+2EGqqKvKxtRQ0l8STEpM0jFHsLo6I9Tn1qBev+K8RKnsFsbwjbUq
         BrapEbCC7O/BRSdKNUsf3XS9/1xo6BcX+9CJhgDSuc2u/Ecsixex7L6ad9ZGzMp9LTyR
         nmJA==
X-Gm-Message-State: AOAM5318AbyeYizj3UcgAAWWz9cR/HkuAUdyAdYqYWKbPvaDY32RBg15
        0ENiY4ouhyjGwd1g9Ehlpeoq3PtZLLT1ykwP
X-Google-Smtp-Source: ABdhPJx6SAJYv+uJf885y9a5uLtV+CowNh1xgbmx0SLwN1v+6/WOxLpLFI9Z+ZknShAi/Zf5Bcg6KQ==
X-Received: by 2002:a62:f904:: with SMTP id o4mr13897914pfh.14.1599343440346;
        Sat, 05 Sep 2020 15:04:00 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v6sm6167316pfi.38.2020.09.05.15.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 15:03:59 -0700 (PDT)
Subject: Re: [PATCH liburing] test/cancel: test cancellation of deferred reqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <dd1698c9dbf0455775aecbb6d0c7e05e444c8ec7.1599342239.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00765ea4-bcfc-2524-7fa3-e520a78af0fc@kernel.dk>
Date:   Sat, 5 Sep 2020 16:03:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dd1698c9dbf0455775aecbb6d0c7e05e444c8ec7.1599342239.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 3:45 PM, Pavel Begunkov wrote:
> Test that while cancelling requests with ->files in flush() it also
> finds deferred ones.

Applied, thanks.

-- 
Jens Axboe

