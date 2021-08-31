Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC53FCC06
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 19:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhHaRGJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 13:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbhHaREe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 13:04:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7B4C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 10:03:38 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b7so25867027iob.4
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 10:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zskmrK4yzteduejG1lBVTd0nx6kXv12dBfaJbX0Tc0g=;
        b=iEkL1qrmeWkD+4y/IvshtZ8WTi6uqSlbIwjl2JCkES6ElldBnJ9YTGWy3ZnwRVcPbu
         bhNF2mZ+RZTzbfV0PqRAgh9FepkBwoekLBCgsLUylUTE1gsMLbmQpXhTCNU2TaVMJ9Qb
         C3TwxgHbgI8Cy3U0vTI5WkiGqQ6XJAQeBV2f/CdKmCQ1eNJykNqzcoFv/y3uUaH2fB4X
         FkeV4u1Wcik8W6Sv9fJof2ycyYznY80EfJrzQNOK+fbKLPVNwcgCTHLBLjBCdNWKp3iE
         9x327wLw/u26kAvdWdJdrlCb77t2RQMuUGBzOYFK2w5iw3b3Lvr+0lobnQrRNOPjMxAW
         lgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zskmrK4yzteduejG1lBVTd0nx6kXv12dBfaJbX0Tc0g=;
        b=tU5DSSfMrTrpoO4Cc962A8b1qNUAOY1ri1PL3gS0zfhxjOxGaafjyK97JOZMGG/BrD
         vhx90yKOvhq1Ur8vw9ivvbBXNsevTI5xzbWBcvdMO7FVl94W0+Sh/Nplj6lKIW6rVhe/
         yI9CWfzSQk5Vf+h8fBFYieJ5Z+CUXFS0xg1907UO6bTj4CsaJdMiz7oRHad4DD6ZxEE/
         WdD2uuM0dJo9LApfKYHiBMaT7bIM5Z7dYwsEi5hGDqb2Jo43G9lraw7Kih/FH6KLD0sK
         fA2bVR0naSpUuj93C6LcDZWJf/zFbMoJDlNVqd79v2WM4DxYe1asUjj6r1BNSPi/INcg
         joOA==
X-Gm-Message-State: AOAM533bA1FIyx0OYxobsuvIb/jr0QLznPuqRvlOAKsIl84oqUAfkl+v
        jXketxnNOsQJPXfG3ysz2qSVeOPPs5yYvA==
X-Google-Smtp-Source: ABdhPJyoGQnYUp7YnYcZY7I5B4MiUDUS28TocDy9ky0Kp3eS6xc7/x53WNZR37spok3qD/uDAucC3A==
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr3709140jat.57.1630429418081;
        Tue, 31 Aug 2021 10:03:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a4sm10170679ioe.19.2021.08.31.10.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 10:03:37 -0700 (PDT)
Subject: Re: [PATCH liburing v2] tests: test early-submit link fails
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
References: <3e02f382b64e7d09c8226ee02be130e4b75d890e.1630424932.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d813efa3-4391-2e3e-54d4-a9dc3e346511@kernel.dk>
Date:   Tue, 31 Aug 2021 11:03:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3e02f382b64e7d09c8226ee02be130e4b75d890e.1630424932.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 9:49 AM, Pavel Begunkov wrote:
> Add a whole bunch of tests for when linked requests fail early during
> submission.

Applied, but remember to check write(2) returns:

submit-link-fail.c: In function ‘test_underprep_fail’:
submit-link-fail.c:80:17: warning: ignoring return value of ‘write’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
   80 |                 write(fds[1], buffer, sizeof(buffer));
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- 
Jens Axboe

