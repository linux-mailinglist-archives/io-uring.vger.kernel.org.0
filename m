Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F394336D93C
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhD1OGv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhD1OGv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:06:51 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4C9C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:06:04 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d124so1031565pfa.13
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HHDc88ds2TWvPbyWZyyRJ8gJX/VYBdJd3UdIURDZN0g=;
        b=wYHgaPXYWoAam6Te2boablqKfN9roWvmdFclCn2KOF1HhDER8cFXNttE8l8LCe7rLP
         0MLS5USBbzliZn5QL/AONkkbh49izwdxJQ9YZT2gt1zMxQzDfqAvEV+mRSfY6r9/09A3
         GO92iqExpinKFYFBtu2NmgcZwrTEj90b16nfLgrCZrJqoRtdoKTliXVsDXZqbx/uo7TF
         uPGZIvZkPKXVx+8+YJrzQyw20ccIwUNuWhUiaNRIHFowKNFK+SkWHlUBYjDDtv3t/cSI
         2qObkOn5/hNQ1HiOOLI7TSl+UFM4Mcf2lcwQYtb/JwwAW22JKPw8pDbVVE3jn++NuAXd
         R2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHDc88ds2TWvPbyWZyyRJ8gJX/VYBdJd3UdIURDZN0g=;
        b=fgAzJa0DgilLixf76uEvJP4TdUsO1djRgCwKolk8p1XZ1Xq7q9qR1vBZ00S4bHGTE5
         NncEXK07Meil9xro7NGbRj1R8mqJiI6JEV3C2g+VoExL2m4SWorwCWe1jiEMfXHqaIm7
         YJk9n548uicn4eJvjD1KHvcJyzexPtzb97C63eVWRGMQ3Kyt8fGDkXue0VPJgiVLJyo5
         U6qMBsSX7Q4WyIqsbABdMO7yaMYT6nvvNnquHG5GH8KyehYqWdA2dT0KXxIx+Hu21UmB
         +HdQO6I2f6nZ55w7uKo2BZATRO92a9/5q+IhLszSmzlsej4/v09BKA+rx6gmI3KqUZB2
         EdXg==
X-Gm-Message-State: AOAM5339m8N5akAfGNYIpU+kMG73K9h0/aYBy25xi06ZM2wHNt5DYvMS
        OvaR0XSDlucOQW5/WPlNjXIVbOgxI/P/Ow==
X-Google-Smtp-Source: ABdhPJzXAZYKpSP90OWs6OfeoCr8bIu5QO1gi+dqVc5HK9sTij03FspxW+eKB559ipdlYp5+s8jp9Q==
X-Received: by 2002:a63:10:: with SMTP id 16mr27698471pga.143.1619618763783;
        Wed, 28 Apr 2021 07:06:03 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k3sm2580451pgq.57.2021.04.28.07.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:06:03 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: allow empty slots for reg buffers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <7e95e4d700082baaf010c648c72ac764c9cc8826.1619611868.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a164b4d9-dede-0417-5321-67ef5ba5a6a0@kernel.dk>
Date:   Wed, 28 Apr 2021 08:06:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e95e4d700082baaf010c648c72ac764c9cc8826.1619611868.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 6:11 AM, Pavel Begunkov wrote:
> Allow empty reg buffer slots any request using which should fail. This
> allows users to not register all buffers in advance, but do it lazily
> and/or on demand via updates. That is achieved by setting iov_base and
> iov_len to zero for registration and/or buffer updates. Empty buffer
> can't have a non-zero tag.
> 
> Implementation details: to not add extra overhead to io_import_fixed(),
> create a dummy buffer crafted to fail any request using it, and set it
> to all empty buffer slots.

Applied, thanks.

-- 
Jens Axboe

