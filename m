Return-Path: <io-uring+bounces-3411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6D498FF2B
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 11:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BBE11F220D3
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 09:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C499C3D55D;
	Fri,  4 Oct 2024 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FoxZvvPn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E393A2421D
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 09:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728032467; cv=none; b=p66mlaUlCUs7PxRzh/Ie/gItGtjq4FlGO9J4Kf7SH8qf7ypr2d3IiP3AEORGPLKzDbaaIKu0JMP6K4xvktNQgLmEuMGr3kNKOCKsMp6WfdwbHaVpD2SQMNa42FkfjqocDk5rqEH603e6lufWr6niT0ranvGelmJehWlJuBmkVvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728032467; c=relaxed/simple;
	bh=I3ULWu3RQDHEM/oB1jUJ0B/thsnQR6NqT0AvPvyH7YA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gTfgtad+rMjySTb7gmmsVquEkosD9pUAZPB//F3HjEZbaYGTh7y0MWR10zGw5pwKEanfQUn6+jUCHsczxcFM9+83jAt2tD3cvtN76NRbW/Qdrs/4/HHDE6nkv/KA0CahHwOAdZk2JBbb9gaUjQ2GzfhcIydt+bfjG3/3e1p4198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FoxZvvPn; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37cc60c9838so1103734f8f.1
        for <io-uring@vger.kernel.org>; Fri, 04 Oct 2024 02:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728032464; x=1728637264; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BP8ae3x+2Q8imY42d4ELyiMTLsvRHxEuygTSIlm3qk4=;
        b=FoxZvvPncO5LJLfcF550upeDWNKrWsLt3YX04Ica+LjMemAlEi2SFMOWfa5UGuZFT/
         qnJD4ip9mzhWba345lCH0SWKM8JRCBCxmkm/odx618xSgqXHFSBnkdIXpspWidzKhIAr
         QWwDd1vX7LXOvpqaeq9BylKfSSnFnrIh1/IvQJaQpuKTfCvuU0u3z08qUyDwdU6oE5bC
         FFiotBbLM97xVmjb1fYsAXPPS13lgp3joRRAvNzaOYVioUvgMWG2ylmEz1ex2t7A7zrM
         QH5QdYyUBo6R6IbK+cLNpUum5xNvshLxdOguB5bFOwALzUaFvpS0qFMrLuXip1eCSxL0
         vcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728032464; x=1728637264;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BP8ae3x+2Q8imY42d4ELyiMTLsvRHxEuygTSIlm3qk4=;
        b=At/Z9jg1IBbXDlzgvY9t6LgQXwHPifl4cd3Bb5G0pHsJiWKqgsbu5vUfD92H4jXIM1
         A57oISUCfyCcdcGBv0X87O9ZS48tunxbC2RUhJ2aihA5BlUbKu4wOZM5t70ORtMgC7+0
         KcUvqaRVbGdGlInWAm23j2SZpQryZiZ6NxoiDzNagUiLe73kATaXwfiFTcd0ySjTtKpe
         Kf7lUf5quKv3B2T0LHr4b7DLNBA3D7Ki0tYHocr242Ck1cQob4wyN6mFshmAITEkLvNM
         wb1T2fjlQNk815qtF/6oUJ/Ozg04dRQRzDwFO50wAsODPgf2yMpzooetJlCngD7XHuHC
         mbcg==
X-Gm-Message-State: AOJu0Ywj9RqbHEbXLaYF5QtZSrpsRmRyAZNrsIz051+OU0+7s2D4nUwK
	tScVYbOaA3VosPKoEY9u4niLXnckFJMcTn0iSA8e5dpe96d3g1QDNxdOXZyddiylDfg5AgqpWHK
	J
X-Google-Smtp-Source: AGHT+IH3qJA8Z2JTGHClKJafU4mCbxGTZQ2o581jxmiRMTrB5RuDoNvPFA5fgdgfy12rwxDIRz8taw==
X-Received: by 2002:a05:6000:d91:b0:374:badf:3017 with SMTP id ffacd0b85a97d-37d0f720689mr945631f8f.33.1728032464004;
        Fri, 04 Oct 2024 02:01:04 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d082a6bd4sm2829683f8f.84.2024.10.04.02.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:01:03 -0700 (PDT)
Date: Fri, 4 Oct 2024 12:00:59 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring/poll: get rid of unlocked cancel hash
Message-ID: <e6c1c02e-ffe7-4bf0-8ea4-57e6b88d47ce@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jens Axboe,

Commit 313314db5bcb ("io_uring/poll: get rid of unlocked cancel
hash") from Sep 30, 2024 (linux-next), leads to the following Smatch
static checker warning:

	io_uring/poll.c:932 io_poll_remove()
	warn: duplicate check 'ret2' (previous on line 930)

io_uring/poll.c
    919 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
    920 {
    921         struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
    922         struct io_ring_ctx *ctx = req->ctx;
    923         struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
    924         struct io_kiocb *preq;
    925         int ret2, ret = 0;
    926 
    927         io_ring_submit_lock(ctx, issue_flags);
    928         preq = io_poll_find(ctx, true, &cd);
    929         ret2 = io_poll_disarm(preq);
    930         if (!ret2)
    931                 goto found;
--> 932         if (ret2) {
    933                 ret = ret2;
    934                 goto out;
    935         }

A lot of the function is dead code now.  ;)

    936 found:
    937         if (WARN_ON_ONCE(preq->opcode != IORING_OP_POLL_ADD)) {
    938                 ret = -EFAULT;
    939                 goto out;
    940         }
    941 
    942         if (poll_update->update_events || poll_update->update_user_data) {
    943                 /* only mask one event flags, keep behavior flags */
    944                 if (poll_update->update_events) {
    945                         struct io_poll *poll = io_kiocb_to_cmd(preq, struct io_poll);
    946 
    947                         poll->events &= ~0xffff;
    948                         poll->events |= poll_update->events & 0xffff;
    949                         poll->events |= IO_POLL_UNMASK;
    950                 }
    951                 if (poll_update->update_user_data)
    952                         preq->cqe.user_data = poll_update->new_user_data;
    953 
    954                 ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
    955                 /* successfully updated, don't complete poll request */
    956                 if (!ret2 || ret2 == -EIOCBQUEUED)
    957                         goto out;
    958         }
    959 
    960         req_set_fail(preq);
    961         io_req_set_res(preq, -ECANCELED, 0);
    962         preq->io_task_work.func = io_req_task_complete;
    963         io_req_task_work_add(preq);
    964 out:
    965         io_ring_submit_unlock(ctx, issue_flags);
    966         if (ret < 0) {
    967                 req_set_fail(req);
    968                 return ret;
    969         }
    970         /* complete update request, we're done with it */
    971         io_req_set_res(req, ret, 0);
    972         return IOU_OK;
    973 }

regards,
dan carpenter

