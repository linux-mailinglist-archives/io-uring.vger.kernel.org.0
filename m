Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6392ABE88
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 15:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgKIOVw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 09:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730041AbgKIOVv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 09:21:51 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E20C0613CF
        for <io-uring@vger.kernel.org>; Mon,  9 Nov 2020 06:21:51 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id x20so8417256ilj.8
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 06:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PiD+QCXtBDfLvlDuhcgqe4m+YTVr8RbaHBLoSJlgGkU=;
        b=VTeljnpMvJ8z3vM5Nzc1USsNIoexI41kNRgV1j1j3FOtnOnjN3MFTr4HjCvdcZCtdT
         VurWUp8ucUfngh3AEeEdVo90Dhwyr1bz1XLcM9t/VbcauepKP5cLbCgGGo6CjkP6tSsE
         PwC0iuAv47V9tfaniB2z6lF5dUE5lxaFZIITYoB4xz2yMoxAlKYlU4Y+LuUojpWb7Cn2
         LvHU5ie0xsJkVoBBJUrjf1mktmOBBDaK4WCR13hO6xg9RnbdovQFhtoJ20ejPY5QrJTo
         AVaRO1ikwGeOHJHqe9nEXRW4XLgQyAeBYAD1L6U2p63P6sKgwyAIRjWd+zimn+qolo1J
         pR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PiD+QCXtBDfLvlDuhcgqe4m+YTVr8RbaHBLoSJlgGkU=;
        b=m6C1VheSUciFhyKWRU5wPICqOiLB42T3MNVRnIWj37j2qGChleCSKYsujgnGStHUR1
         JfBhvrNfWLpHYiQmkACSR7g2k/jCEGBgh8U5MH0UFGXV2y4UEWgAmrBcLln/iVTzK0Jb
         D3tQm+mXbGkurvCTHRgKVVIxrJHRDN83vifO6TbX5uWf5Jqiim8CIn6U4yXf0hcmdaCy
         oUEA/BmvFZ7KCufe0YKhFPbzuhbb5MFL66cRzCoQII7dUsvB/PKZ7BHF9eX6xeT3HzkG
         NQfQSIIOiomk/NzzOQxJu17B5WRQEDmnyjCzCMhn6P0T+4yF8wsUOnjImigxqrcn9ZyQ
         2DGA==
X-Gm-Message-State: AOAM532kUoHPJiD7iu5rVfzaGb+75q0hcIJyYxWdGWORrW2pBZeVM1a5
        ZeGZZtdwCMDsnazncJGbMVgHDQ==
X-Google-Smtp-Source: ABdhPJz4ZEGdbKxL6CPgeP1ZMrP1jkUcytus4JRBS2WpDDAVixl01lb5y8P7ittu8d0rRxnNrAN43Q==
X-Received: by 2002:a92:844b:: with SMTP id l72mr9818565ild.244.1604931710991;
        Mon, 09 Nov 2020 06:21:50 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a1sm5862727iod.39.2020.11.09.06.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:21:50 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Josef Grieb <josef.grieb@gmail.com>
References: <d30884b71aa3e74c53a1c1f531b957cad222b7d0.1604840129.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <751ca058-88a9-d947-f65a-7ee82692f867@kernel.dk>
Date:   Mon, 9 Nov 2020 07:21:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d30884b71aa3e74c53a1c1f531b957cad222b7d0.1604840129.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/20 5:55 AM, Pavel Begunkov wrote:
> SQPOLL task may find sqo_task->files == NULL and
> __io_sq_thread_acquire_files() would leave it unset, so following
> fget_many() and others try to dereference NULL and fault. Propagate
> an error files are missing.

Applied, thanks.

-- 
Jens Axboe

