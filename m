Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C0D3C3FCA
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 00:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhGKWmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 18:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhGKWmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 18:42:13 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC7EC0613DD
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 15:39:24 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id m3so10772799ilj.8
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 15:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TIkUsS6MXECygoKMycFiShTcnCGrVXDvplg2DQF4Ld4=;
        b=g3xR/nj6i1L/LPKYrenTorc3HOQWFuy0PQ1ArRS8mUMZ31BOKFZjQ3SZNmxx6QDbD5
         yUpmHC/IktDZhZv89mg18+EtlQdjABbjGAZIdINx+m4VjaLWaSf8fLvnYRL5mQV9hYEd
         bwj2l3m9jHVU76NphBaVFIQSlGXbaGBSgHWaTCMC8nVjaIncwJAC8bUdkV4OLuBSZL7G
         uEsBbPNhD2iTuCwdX3uOEBmWkr8S170l8J4oUTkZeQIV2rul3gD/BcwPQuxO8n47Xsje
         iA4a96H6hKleCEfH7q1rIMoTOFoU0FxCVf4vLiTJfSr5iyUMoL6+fw7qg41Vr0ZpI9Vo
         X2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TIkUsS6MXECygoKMycFiShTcnCGrVXDvplg2DQF4Ld4=;
        b=i6ha/5RY2uOHxUwr1ro+KGselerh+ZMJA6jOkDEOteIQXHS6HXjPi1PCTpf+1sbwMY
         XplO3Q1lzggMAHz/48dgXSr+2gNeZHSLXCKWWfjLu20dz74/NDMrzpC5wAguP32nw4du
         fhB0oNz5tyXtD6rd8EoNHzmKfYS6yvfyo5V/SThPeTj0d937cEOqkO2M9R6y8nYN9g1o
         erUG8dhN/HlV+3Q8vcuJQ98HH1wWZupf41aJ7ZPYHQ+qxZ7CxHwvYN/gkOX9+fDUmF+j
         HQRVdAANGtz9p78umrf47Z13fzGDXlhtZIK7xVExPtJwG4Zyc7xM1LBOZXeLqryeEsBa
         f/Pw==
X-Gm-Message-State: AOAM533BgBw5k1EJ8IY8m4jN9r/o6KTkm75Ar0BDr72Rub3NO1Ww7JDt
        CyCFWGJGCNq55CXoFV2jQFlneA==
X-Google-Smtp-Source: ABdhPJz1pNERBQ7rtR2WJoqkpkqv5SqAgsgnBFw8++zAQoCBtLksmfo/1fSkz9nhS3qcqcvewsGVQg==
X-Received: by 2002:a92:3207:: with SMTP id z7mr22292886ile.288.1626043163830;
        Sun, 11 Jul 2021 15:39:23 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id z6sm878097ilz.54.2021.07.11.15.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 15:39:23 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix io_drain_req()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com
References: <4d3c53c4274ffff307c8ae062fc7fda63b978df2.1626039606.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e339241-1517-0458-db8a-3d364ec0820d@kernel.dk>
Date:   Sun, 11 Jul 2021 16:39:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4d3c53c4274ffff307c8ae062fc7fda63b978df2.1626039606.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/21 3:41 PM, Pavel Begunkov wrote:
> io_drain_req() return whether the request has been consumed or not, not
> an error code. Fix a stupid mistake slipped from optimisation patches.

Good catch, thanks for fixing this up. Applied.

-- 
Jens Axboe

