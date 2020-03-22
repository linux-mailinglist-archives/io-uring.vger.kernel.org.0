Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE1E18EC15
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 21:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCVUQE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 16:16:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33139 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCVUQE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 16:16:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17so5486713pgo.0
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 13:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=s/wZQcNYe3sVJrJyk/B5WQN2MX+ZGiqPClv9613s3wo=;
        b=SwwNZdFEWTZ//dfICgi+u75oPVUJrzw5feC1te6YYVADXCcTuaHO/CztevFy861LL3
         98w6rqrKDt/yQbXRSwxyGuVKvkeZ2WXJ4ja1P1IHP9RIPS33UYI3C85zLDQHzFnLCCV9
         bSPxScXQUz3hNHrstxdoP3aFp5Y/c2aTrpXaPKeCRLSlo42bDilZlcX+CRl3GSLQf5Bg
         /Y5eFws/ByyHMfucNaBvUj+wmIvUs2OnGjyS7/zh76P3PVR9clgQEHcglngnmejpv2m6
         5b/XI420gF0PkTzshQVssQ5h4LHwR0fALKbKJF2aqla9rBMoRQjurNQ3qopXHkrATTgr
         YH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/wZQcNYe3sVJrJyk/B5WQN2MX+ZGiqPClv9613s3wo=;
        b=SDte5w+cvHG6eaA+HccEFNE5W2ZYFKF2a0nLWCH3jZWBBJxTxiL2LKgSb2Ob4+Tdex
         DTZmiCUsQIDBZc9qLYyW9c048tj6p1G9DQkeH9qR+Vi3Fav8SV1lomYBzKgW20SfYu3W
         A6K4BQKccAIwI7UV8/4qWK6Ha8QdQTYxMeK0NFXr3rZQnQ5qJaiapMjFOH1tIi3HgI/7
         D3Q9HKeL6LssMKaJ3kIEkt0/ZW6beMPc+Q3TtjUBUYgMfATa+vkRCIflGm1FaLalLk5/
         eWaJL7vB+l2/YR1kqdEESPIXmhTmqFQyKXkxAVikJCnim+QmRd5CL5Xw6MdoI5sUMcpG
         Jlnw==
X-Gm-Message-State: ANhLgQ2JeFjOXLT5LrMkFAu2JintAwOlEvWBN5vH/sz9DP+bYc76zFoY
        4PBi+9GuqY1awDidBrdp4ixoRO+lbnjTJQ==
X-Google-Smtp-Source: ADFU+vtsPw2PP3jvnjrWGaLCY6C2x2sgy6xaGCFeh8137t43Z/jyAra03v7aw+FOYvNs/a6GRe16+g==
X-Received: by 2002:a63:2:: with SMTP id 2mr18084722pga.102.1584908161354;
        Sun, 22 Mar 2020 13:16:01 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g18sm5239702pgh.42.2020.03.22.13.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:16:00 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
Message-ID: <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>
Date:   Sun, 22 Mar 2020 14:15:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 2:05 PM, Jens Axboe wrote:
> On 3/22/20 1:51 PM, Jens Axboe wrote:
>>> Please, tell if you see a hole in the concept. And as said, there is
>>> still a bug somewhere.
> 
> One quick guess would be that you're wanting to use both work->list and
> work->data, the latter is used by links which is where you are crashing.
> Didn't check your list management yet so don't know if that's the case,
> but if you're still on the list (or manipulating it after), then that
> would be a bug.

IOW, by the time you do work->func(&work), the item must be off the
list. Does indeed look like that's exactly the bug you have.

-- 
Jens Axboe

