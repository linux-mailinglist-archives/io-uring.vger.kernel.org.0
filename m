Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926043EC9E1
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhHOPUI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhHOPUI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:20:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEE7C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:19:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j12-20020a17090aeb0c00b00179530520b3so8039815pjz.0
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A06COi7+3IJrHHjXOfXKqJU+Qdh52+7VC4WxKYXlKzs=;
        b=y7sEAPdUQZcF3Z5PrLvuMsQbebgUP5ZPIXMK378W0jnrbsmTFoED2XoLIvP02ATcca
         Q4WjHJXETPPYJOK72YIWD/nY177C3Z6IkaQB5Yl1qjdVLtVZSB+XsTxI0EjGpJbD8jd7
         wGGNJUj7OjWPe+hrc58xx75NtaL53OytzuevDeOCqqD1naIjFVAJcRLv83nPKLKgdmrA
         RbxgW0VwkyOMMC6ol0J8YIM4aZ6lw31tiij79S6cqVlxr5nG26vNxoBpOgcI5w3XJ9WB
         m+KlgQnVIlIKJVDhYUOX2JHM+K1ictE5qy5zNhGJKIwHkMonSbDRPO7sDO7kR9oReO/1
         1W3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A06COi7+3IJrHHjXOfXKqJU+Qdh52+7VC4WxKYXlKzs=;
        b=TGBg2seufpcZcBu0tnBRBo9u02Dc2YOSWIH3nuxajlZjr+WJBZaMhMdMSdoxQW4066
         54LYjvHPt1qeQPDNYAXYr09SKa52TKPTy4YdeJo9vo+L+6G1cvv22pUZRdTvr1k1M9P/
         sCnMcEMHqa9QDzLAjC7fwCKJ56y6I66iiZMkGI3WnqWWwj980FsQKod/c1njoGGIFNP+
         pVkEfIq9YKVdT7+y3zqi03vGQm2hO1PInmbWpR0yZW67HUD8doWBBu31/GrfGSOodFO5
         8OCQzmWvsQ28xa7Xj3CwWtjKf7SpuEh+GMRdLXjpy3PNhvbLW+Dc2RqjQRzZYIqyCtPZ
         JpOQ==
X-Gm-Message-State: AOAM5322dWOW+vkBmnWBlEbQhns9t2BXwbR0/teZBLktlSJaJ+fJfeKM
        CV0j7HNvDD5BfOxCeRbScoUcWw==
X-Google-Smtp-Source: ABdhPJxWUYCiWTNuNT+H5+N6aMjks0/50OvTTXxZaX31kS85qnOSu3z1Psf6nQDNRCIuvVulFCPNBQ==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr11585308pgj.272.1629040776961;
        Sun, 15 Aug 2021 08:19:36 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c17sm6871434pjq.16.2021.08.15.08.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 08:19:36 -0700 (PDT)
Subject: Re: [PATCH] io_uring: consider cgroup setting when binding sqpoll cpu
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210815151049.182340-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d0a001a-bdab-9399-d8c3-19191785d3c7@kernel.dk>
Date:   Sun, 15 Aug 2021 09:19:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210815151049.182340-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 9:10 AM, Hao Xu wrote:
> Since sqthread is userspace like thread now, it should respect cgroup
> setting, thus we should consider current allowed cpuset when doing
> cpu binding for sqthread.

This seems a bit convoluted for what it needs to do. Surely we can just
test sqd->sq_cpu directly in the task_cs()?

-- 
Jens Axboe

