Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26EC17CF14
	for <lists+io-uring@lfdr.de>; Sat,  7 Mar 2020 16:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCGPgf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Mar 2020 10:36:35 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35336 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgCGPge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Mar 2020 10:36:34 -0500
Received: by mail-pg1-f195.google.com with SMTP id 7so2567468pgr.2
        for <io-uring@vger.kernel.org>; Sat, 07 Mar 2020 07:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=X8Q0iQvt9yySsKBxTObcLgqNokyvnZ8EgfUe1/v9Oag=;
        b=o6S4yzpEbBoXuEbGBPbuI2aVMha7Hq4/PaqQ+0ISNq4VryGl2gneRQo1uyI5G8y+sM
         MPep6y8foCYeMdjVWvSmCeZEwaoTKAss0DymSfmCUSw5mmZy8dX5EYd0dbPtFQauatHF
         Tq4KA4FK5iTzaF1F4yo8NafTb/L4UDtzPK83LM7ZmbnT7zKe0gGyKf3jHiMrOQMIAj1Q
         MfomBNKKxgx1Conwk1sof1Cok2NUDN5FKrEfTepJgbx5JaYYRiaLnCHu9LKwQNVYkhgJ
         FMMS37a1CReTT0N3q6GxYYXPvCZBvu2NdjFjkSSS92EVfXv6oWmHy5AHH69Fg0i8xEGb
         d8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X8Q0iQvt9yySsKBxTObcLgqNokyvnZ8EgfUe1/v9Oag=;
        b=Ue+dIdn6FiRkzHIv7TZcrYDWcfHnhIJT7VCrAhKU0i1QrfvhN2iLBow+pQxE2W5TPJ
         n/YLrgg0BLS3vH9vRhzvazCtuhnNpaMqYSYMkbs7j2xV5lVtAOrObwi9WTFIP5GfZARC
         +vFCAogsqcFpOLivF9AUMv+rkp+Ft3dUFBcBP+VWLHNK1iYC+FcUrixwauyQVv+aLcYN
         PnyvXUbApqLWx1zoZtuZ+YWo1Kac6oadNY3JjXs79fde8gMODkYhCIWpRwKw0DOo/8QP
         9Fga/VxdJKOxq7Q/PFzQtRki3QBqR2JNbxOlvFRMs8Ak4LRLhb2j8T00hJIny7PamJoY
         q7Ew==
X-Gm-Message-State: ANhLgQ3rim57C+HSvuahwSaCHWBiNAST1FUGoQiJFrH6roLApzfy0Aq4
        l5m4E5Swd8z0+9dpNz627n/oDw==
X-Google-Smtp-Source: ADFU+vv/CpDAMDYJcxi9ndwAxm1jhXPFLdwR0Dr7LdLSFsjt7ExIeOBElk+ZsZWGCaJjSUGKsulRyA==
X-Received: by 2002:aa7:8502:: with SMTP id v2mr8739393pfn.232.1583595392111;
        Sat, 07 Mar 2020 07:36:32 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c18sm38291906pgw.17.2020.03.07.07.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 07:36:31 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix lockup with timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <54e141c75da11f55f607d53c54943b9fee5bbd70.1583532280.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4a96385c-52ea-cba8-455d-6fd3042bd49e@kernel.dk>
Date:   Sat, 7 Mar 2020 08:36:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <54e141c75da11f55f607d53c54943b9fee5bbd70.1583532280.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/20 3:15 PM, Pavel Begunkov wrote:
> There is a recipe to deadlock the kernel: submit a timeout sqe with a
> linked_timeout (e.g.  test_single_link_timeout_ception() from liburing),
> and SIGKILL the process.
> 
> Then, io_kill_timeouts() takes @ctx->completion_lock, but the timeout
> isn't flagged with REQ_F_COMP_LOCKED, and will try to double grab it
> during io_put_free() to cancel the linked timeout. Probably, the same
> can happen with another io_kill_timeout() call site, that is
> io_commit_cqring().

Thanks, looks good, applied.

-- 
Jens Axboe

