Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09873F9A15
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 15:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhH0N2q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 09:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhH0N2p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 09:28:45 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F205C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 06:27:56 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b10so8463092ioq.9
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 06:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z8wDsCC0cU6Clm7nveS8NfB15NF/uGP7eQB9XmAuIvo=;
        b=W9p+BlUh8V7FCCS/xRUag92NtZdK5veCm/CLp49VBGZknM6D9tvI1DCOm7uhM1XqWj
         kd1sylsJ/7ZcC4nYrPuomeThfhQll8oQZ+BDNpw3d9p9nHRkXE1OXi4W1fdD7vhUYsGl
         ZBpysVyglzwSaTmIR8kqiWL9r5VOEo5rTzcOerfmfhbFut7DAK2CEvf6Yb6YW61icuP+
         TgwgC10Zk4YL7wlvJ2P7AnEiVEWKKwszClMY8Hv+vvsxNr3YkgJKSOt3A8E0RdUrN2nr
         pXV0tblW4J5h/HznrW3QGTbgbaYF/zLJzHTElw01gZrDS+rHuaVy7oqbGOLv9v0FyQbI
         BmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z8wDsCC0cU6Clm7nveS8NfB15NF/uGP7eQB9XmAuIvo=;
        b=Rc3lvaXTyERlS4M+wTQ0unsIhufH0Fmyd2cWRLE+GvfILpj4B6Uz5HAM9RdhTTbmNG
         9dxOoKjixbwFszCBFHMo9vG6bsReIe36N2AtOK+2DFu2240Zeg+GwIdc/UyFei0AoYIs
         bieNhK+PtPGi3PN5W8TN/MDxZnCi+BZEgpCq6T3k2aWLWQ4Natkf3P1KzTgdeRg8quva
         /LPp0E4CvnkB4TKYin3UOtz4PNvMRJyE6En2/VkN9tXhtUq+2/zhM10XheakIi1y5Ev2
         T6w4ku/N/1jT/HxVYd5zMg8p1JKo5lw035aBGtFBCifqRGZwWR+dHXn9AJVWltb9kdtq
         a7oQ==
X-Gm-Message-State: AOAM530yRr41IGDP+NXjf0GcoA2SokjsFpMXzuKiYTcNHKKnzhy/jXvA
        Cym4GRCj4V/adIQcX8G+usWcVw==
X-Google-Smtp-Source: ABdhPJxWVAAWsSAGt+M9MmrB/UzJ432ufOXYCr+i6ehfAxIORmgWQx3uzzgfTn5RmPhWliaAaUYFfg==
X-Received: by 2002:a6b:f30b:: with SMTP id m11mr7117050ioh.0.1630070875710;
        Fri, 27 Aug 2021 06:27:55 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m10sm3497455ilg.20.2021.08.27.06.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 06:27:55 -0700 (PDT)
Subject: Re: [PATCH for-5.15 v3 0/2] fix failed linkchain code logic
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210827094609.36052-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40dee78d-1283-1067-cc7b-94b493eb2150@kernel.dk>
Date:   Fri, 27 Aug 2021 07:27:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210827094609.36052-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 3:46 AM, Hao Xu wrote:
> the first patch is code clean.
> the second is the main one, which refactors linkchain failure path to
> fix a problem, detail in the commit message.

Thanks for pulling this one to completion - applied!

-- 
Jens Axboe

