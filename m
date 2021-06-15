Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0A93A8B32
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhFOVjp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhFOVjm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:39:42 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC58C06175F
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:37:36 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so155776ood.2
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BNZDhyuQiy36D1r83AzhJvC36jFd8GNMJF0umN1XQ3k=;
        b=2Okh3fGr5tKEnaVRIv2XO8JiCngsW8bg9ekpblQ5m4R8nCN0GpWiMs/rRdijFcqkXf
         t+An0g2Yb1PVAvD5zVv2kJEaR5z0HJbExysPltC2z0/M8dV4MmjaX5zVxq78tVcLgw4W
         SbJ4RvgX3kVpT/AT4jYhHRopOA5mDsLcoOm8Hy33NCkyZs1ZtcTkfrjylGwOcr0LhLkO
         jI1qaqNGf4utr4jBtRF07ayiKNhAH2C6P56Y0HvG3UTFTQE+F/XzBGiB16bmhfPk1r/l
         gOnq6IKGZE9sCUJbNxSt/uAFhptDNo9PKHPcZG/HNteShxNbpky1LAzaCqwjIorW8fsg
         Xn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BNZDhyuQiy36D1r83AzhJvC36jFd8GNMJF0umN1XQ3k=;
        b=egzSHlMeRkUwMyrZgcNI6A6HEPO8AJa7D6IOc4OsfsIll37sEZkKCQpRb9r1r2UdVO
         J2nNP5eZ0I0Nh/NFh1yuQ81bFJ/nLq5vqdxh+1OVIwwn9WsQ8yT5RErXiiu4A5fG4tmC
         DRNbSKLLIx3ZI9BeoJ81TBv2UfjZR3pv2p1EM/9fExByRAuvFAZi7ruAvbiH9HMCpVME
         BYO9LEz6bgNKvjIqrs0lIM0qbOdUb6rFoJP66kpvhyS/yp5JvOrCZoboS7cxKZTOT4zF
         YHcDn67A0Ne1ibpmt8tLUbgosVt+B9t3lSrNGE+e2bTHZgEK9BAQA7Tnn4airDMkxhyp
         zYjQ==
X-Gm-Message-State: AOAM530k7Qwcz4nPgF2GHjIgcRq3E8Sfds59+9CnDYnpfcMJzjVtArvt
        S4xTjXCQFw7FSrey8vAzm/YSFxfbE/QRrg==
X-Google-Smtp-Source: ABdhPJzcb98//bNrZnTNjspwsEtwYhjL8bdRqZFBU4PM5HoAVHr3gKmWv5njZFm7Ht8onQeKLbPxGA==
X-Received: by 2002:a4a:4c8f:: with SMTP id a137mr1006772oob.65.1623793055844;
        Tue, 15 Jun 2021 14:37:35 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 94sm43414otj.33.2021.06.15.14.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:37:35 -0700 (PDT)
Subject: Re: [PATCH][next][V2] io_uring: Fix incorrect sizeof operator for
 copy_from_user call
To:     Colin King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615130011.57387-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90dae495-a383-8afb-85c7-293425338b7c@kernel.dk>
Date:   Tue, 15 Jun 2021 15:37:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210615130011.57387-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 7:00 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Static analysis is warning that the sizeof being used is should be
> of *data->tags[i] and not data->tags[i]. Although these are the same
> size on 64 bit systems it is not a portable assumption to assume
> this is true for all cases.  Fix this by using a temporary pointer
> tag_slot to make the code a clearer.

Applied, thanks.

-- 
Jens Axboe

