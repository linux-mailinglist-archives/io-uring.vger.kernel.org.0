Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970A847794F
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhLPQhB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhLPQhA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:37:00 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5537C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:37:00 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h16so22569606ila.4
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b0tUfEDwLEgAWdQcAg7deP60ErmXaKGy36F0aaX7os4=;
        b=sYYHxKlbf6fMXEPtKdwtAP8PvSg0n65C7qAV9GhxaTpBSHq1fKhlBEU0AUsIUxmAWn
         0PyvuNQXWIs1IY8F4zicDKFi8bM1/PLBF8xgM0pt7xWSepfu4b485pv4ojs9PM0Z1J4R
         AYxU2/t7W1l5L+ATJckl2z/kT8cdu1XBMEyMkGe8hZqATMiuOJx1yOEfRxFG3FXsx8Zm
         wM4etQoT1IP95ZaN+TFI7niLnvl2vFNvDVnjtoFqL6wUobGIFByMV+j+u90xwv0hLvwt
         k9NCR3hKnV0mIK503ljPtpdnv2chxJYceymi9bNQIM5isBI0HZoRKuEbcuRbDljzFwpZ
         tV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b0tUfEDwLEgAWdQcAg7deP60ErmXaKGy36F0aaX7os4=;
        b=dKtuPvPYAH09jOO+afIka0i7LuOJ/PfBCMbQUGuzxKg7gIrLEkAo7GSJZxTPrY1gAt
         5j5JeGTJATf6gZnjRhnJDmZmSk9B6bHphAeabpCp9H2gro8OOZNp+sdULhjQBANwHd/H
         X0qC8MnEWOHmKtkRcp6C9Lg32JXDJSwKJQ1+2PaRx6lJzvU4DpRwHz+zP2fl/Xb8K4HQ
         IhvXpG+6J3KquprecB+0cjOaCNEBNzGkWAACR89FoWsZr7ys7HJvwMxMdZYTJJ+8d5Ny
         rNeGuVL6lsp7L3DN7mTQK5DOEyGE80GZvryg20PYJeeJF1/ZCOSVfIHytK6VB5Jc3Tu7
         Ugdw==
X-Gm-Message-State: AOAM533GANQoxhH+gUDVMB9TDYaytKAGWKo8uGXYBemoyqUfaACzXJFm
        IoNM/+7eHqmLGZ+fHZnTGESQcg==
X-Google-Smtp-Source: ABdhPJzpmskZuLx90OXi7btpLqIEuoDT98iBxa7blsO/MV1NWiFmJSYpMKaVFg4uIKJLqjIT2A3hCw==
X-Received: by 2002:a92:d849:: with SMTP id h9mr4050363ilq.181.1639672619988;
        Thu, 16 Dec 2021 08:36:59 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s3sm2934794ilv.69.2021.12.16.08.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 08:36:59 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <83aa4715-7bf8-4ed1-6945-3910cb13f233@kernel.dk>
 <YbtmPjisO5RIAnby@infradead.org>
 <db771bc2-4d7a-ee1c-aff7-f8e37dc964d5@kernel.dk>
 <YbtpwAP5HJSKAjh8@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d54331d-d0d8-4164-918e-96e17dd99d89@kernel.dk>
Date:   Thu, 16 Dec 2021 09:36:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YbtpwAP5HJSKAjh8@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/21 9:30 AM, Christoph Hellwig wrote:
> On Thu, Dec 16, 2021 at 09:27:18AM -0700, Jens Axboe wrote:
>> OK, I misunderstood which one you referred to then. So this incremental,
> 
> Yes, that's the preferred version.

Respun it, will send out an updated one.

-- 
Jens Axboe

