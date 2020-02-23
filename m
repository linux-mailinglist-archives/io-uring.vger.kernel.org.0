Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A840D16965B
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 07:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgBWGAU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 01:00:20 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42959 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWGAU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 01:00:20 -0500
Received: by mail-pf1-f176.google.com with SMTP id 4so3556372pfz.9
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 22:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fM4jKj6P+l9d3SfvfXGCjyUFV/zbQUhYu4d/cEnWvg8=;
        b=otlnL6T7nD/3diFzvUwkHu3qCLJNkP6qt2kFe8fbAH9hhDwCzPSe2z2S2W1gL969fY
         maE+kyFixwaE5MdCauqAB3Nd00pO0c8rsNTELD8xCQeUTLltfuaMfUAjiHOtfsHFNHl8
         /ojfUqYxO/uiT6Ew3tL24mOvTLHFGxojQx/hqfgwZ8sR48Izh0y45ocw/s7olUcEpG8b
         a8eVj6RV91W7Lec7yE7e1oCzcdAd/NIJ2JUpbzKAwSGe4yTI6RjI05lNcWHBVdpYncZj
         8kYy0FPlbSURLv0csz1cTWK6VuYeNlQ2rJZhLJ+Iy86aDbNTRwtvjIAMiq+YxuVoIUFR
         aAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fM4jKj6P+l9d3SfvfXGCjyUFV/zbQUhYu4d/cEnWvg8=;
        b=p3UR8EBhn+XVgn2qS/evKQmKVeYOD+ozLd3O+7tWWofp6hHEXE/kiADxcizw7Q3sLW
         evsFfTnl4mfl5behxF8uRixQYR77NwrJsuLrSJCFcKQy/lkfNKnVpYFa3JM48KhEX03f
         feWAM+Kx1We3uFJk86RSb8QfoMMyasRhExrpOjR21VDP2tIMLLcyMe+qV76pHxf5uTPB
         oeV/EOIGoB0IMjcunkhsxvs2pOJM7MB6f8DkW6YAYmWcLx7GmlbzrgO/7UM4jffh7A7y
         25MRYrMkt/H4vICeXm+ZPp1IPLzVe8faRQZJc38vHtizeHxdPw6evJhcd5ZV5Naxt+9i
         8MwQ==
X-Gm-Message-State: APjAAAVe/4t3zTiRrqqdR9Vf/imqqLbKzOd50oLLmTzgr2jcyYUpYFaJ
        SeKfU3U71kB29WI3wXke+p1mfSnrTIo=
X-Google-Smtp-Source: APXvYqz0WcGDCkCKDW3rcnk0CmV6BtgrJzY2WkBLkQcsiL2eiVrs7fEQiB8ggwqtpsV5rDVXEMsCEg==
X-Received: by 2002:a63:60a:: with SMTP id 10mr41347711pgg.302.1582437617924;
        Sat, 22 Feb 2020 22:00:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y23sm7806228pfn.101.2020.02.22.22.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 22:00:17 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
Message-ID: <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
Date:   Sat, 22 Feb 2020 23:00:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 12:10 PM, Jens Axboe wrote:
>> Got it. Then, it may happen in the future after returning from
>> __io_arm_poll_handler() and io_uring_enter(). And by that time io_submit_sqes()
>> should have already restored creds (i.e. personality stuff) on the way back.
>> This might be a problem.
> 
> Not sure I follow, can you elaborate? Just to be sure, the requests that
> go through the poll handler will go through __io_queue_sqe() again. Oh I
> guess your point is that that is one level below where we normally
> assign the creds.

Fixed this one.

>> BTW, Is it by design, that all requests of a link use personality creds
>> specified in the head's sqe?
> 
> No, I think that's more by accident. We should make sure they use the
> specified creds, regardless of the issue time. Care to clean that up?
> Would probably help get it right for the poll case, too.

Took a look at this, and I think you're wrong. Every iteration of
io_submit_sqe() will lookup the right creds, and assign them to the
current task in case we're going to issue it. In the case of a link
where we already have the head, then we grab the current work
environment. This means assigning req->work.creds from
get_current_cred(), if not set, and these are the credentials we looked
up already.

-- 
Jens Axboe

