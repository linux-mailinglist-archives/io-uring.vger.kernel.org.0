Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29D94A4F55
	for <lists+io-uring@lfdr.de>; Mon, 31 Jan 2022 20:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359494AbiAaTWZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jan 2022 14:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359486AbiAaTWY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jan 2022 14:22:24 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0154C061714
        for <io-uring@vger.kernel.org>; Mon, 31 Jan 2022 11:22:24 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d3so12307003ilr.10
        for <io-uring@vger.kernel.org>; Mon, 31 Jan 2022 11:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=L4RNZbc4w/g6bRZEOvYO7HJzVWPx+tOq9WaUROcOiD0=;
        b=xi8lYigDAKDAxC39RiP8JcF5AbPo2ILqABwV3/YQkdWPmoj8MeUmNObgRMrOeflERO
         ZoF8pSTz4rwWOPHxBOGT7/nGfdNqqe+ru8R+Lim7/uoGUOfCFQbLSZmNHVYlegts+JQe
         zY5yH08nko1pYnpacC8fAhZ58zrbiZE+PQMGXDVTWEp/z8pq3pLquEgbe+smlwy2ui1v
         XiDVgESWviPj+wTc+e/dQWl+JYlBV6Q7gGpCsSInUXFvj4Jur85VoRmb98mPDoJYX94y
         ySl0fKatFcjJy/kVTthwWkBllnjlDptD7hSAyFtej0PaK+l3CK+5ZzM2Gt5g6LeUpL+U
         yUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4RNZbc4w/g6bRZEOvYO7HJzVWPx+tOq9WaUROcOiD0=;
        b=u4KPCtcO8ZF9F5QXvk/x8tlu8ewY61HSe1+51ai775D5gLozJd0Z0jDA2xNn4wZ1ZJ
         RJOyuRYxOXt0yiqcQHS+usflBUKXnrkGzSo0x1A+Xfu3i0hI4yybzJxM3qBaR8d+kq7m
         6dH8olABWAfTDVBEBNQ01dI9yLKPqUgsGbLCjMHDZzUWMIasv9DQUb6Ter9N38RrnxZz
         X5fxRjdDl3FFK3CJXcMZItBOdIb0Ww7MNQji/YkUR1XtK82FEHIF/p/+Ub9S4bX3x79r
         RTAdEPf6rMM2mz7T35Syh+oq8MZVxNwWMh0y+ckuYPyNYfoDnucrcw0XBnvedIypvdCm
         1rKg==
X-Gm-Message-State: AOAM5335F9RysIX0I1pz8VPWZyBMc5LS30n1ESZS8eWUO9CJKBVGYZ7l
        9Dv9mUCaPzxqhWGFnq+Vc5ZQ1la+uLHCJg==
X-Google-Smtp-Source: ABdhPJyj/xY4mU704/zlxrsCzWoucnK8V1IvczV4cx0aaAcncXMFTg1y8+Unv+RqgjJ59p9zc3HmgA==
X-Received: by 2002:a05:6e02:1449:: with SMTP id p9mr325629ilo.289.1643656943562;
        Mon, 31 Jan 2022 11:22:23 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s10sm2211176ild.84.2022.01.31.11.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 11:22:23 -0800 (PST)
Subject: Re: FlexSC influence on io_uring
To:     Spencer Baugh <sbaugh@catern.com>, io-uring@vger.kernel.org
References: <87o83r7n1k.fsf@catern.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <da4114d3-e2de-9f3e-5b7f-9b01f091aca1@kernel.dk>
Date:   Mon, 31 Jan 2022 12:22:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87o83r7n1k.fsf@catern.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/22 11:55 AM, Spencer Baugh wrote:
> 
> Hi,
> 
> To what extent, if any, was the FlexSC paper an influence on io_uring?
> 
> FlexSC is described in a paper from 2010:
> https://www.usenix.org/legacy/events/osdi10/tech/full_papers/Soares.pdf
> 
> FlexSC is a system for asynchronous system calls aimed at achieving
> high-performance by avoiding the cost of system calls, in particular the
> locality costs of executing kernel code and user code on the same core.
> 
> Implementation-wise, it seems broadly similar to io_uring, in that
> system calls are submitted by writing to some location in memory, which
> is later picked up by a syscall-execution thread (ala
> IORING_SETUP_SQPOLL) which executes it and writes back the result.
> 
> I'm just curious if there was any influence from FlexSC on io_uring.

Wasn't aware of this paper, if that answers the question. The idea for
async syscalls (to me) date back to the original threadlet/acall ideas
from Zach Brown and Ingo, though my implementation ended up being vastly
different. The API with the rings of shared memory was a pretty obvious
one and not really novel, it's been used in both sw and hw for a long
time.

-- 
Jens Axboe

