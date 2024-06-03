Return-Path: <io-uring+bounces-2078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF1C8D846C
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 15:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52C81B226EF
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 13:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20AC12D766;
	Mon,  3 Jun 2024 13:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRzdFFWX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7871E4A2
	for <io-uring@vger.kernel.org>; Mon,  3 Jun 2024 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717422823; cv=none; b=TyUKKcMj2UEzt7UCdOzZSkLpya393H5J1GD9eT//ZqhMtGJDdSzF4+yDHpo2kUICYkppsd/CDJHAT5UKfvJwyNDgxhmVx2JKRsRCuSR7zn8x5cl85M4XsG3L8FWQT1WlnUj7ALn8au+sw0GIsmW3xY+iKeRLHrIKzAv946jpL9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717422823; c=relaxed/simple;
	bh=35Hqyc8Tkd2FcgsyG9y7jKbpCElsCjDczgKga5aUCy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZG0YUN372I/7QJVp3yS9U1klo8Ku3snXXbmTzREevcxxt6mc1AT46w3bAOMUrDk+IuItbPsyBocGsY7q8p9R3UwWZn13J9RsV+0nlTtWpwJyOubsVbLm8f3Ja/rNV6P6yJZR7zEalkzS6pmL4OV33U7lTtT4vAeXHTsW4dezQk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fRzdFFWX; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57a196134d1so5039928a12.2
        for <io-uring@vger.kernel.org>; Mon, 03 Jun 2024 06:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717422821; x=1718027621; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D113Qv+a/qRkarYonAqzqUl+SWbIin+fbm/bKeRDIK8=;
        b=fRzdFFWXpnjjgwfQwnvwykDBw79BMoq6IuiW6sDrbadIgVl8o4nkSsiVFxFSiDpHnH
         FyiC9JP92SeSwSGxEoL0a6FbtsOO14MPU/k+DppJKzCB2U3JOp/rW7fxp50CEPcNkOpC
         iuCqGuFTe97e1L3ViJdo2IHncccjWNZc7jylq29ZUZK+xrYtl1h8xBR66SV9hTrawBU3
         /rTu95G12GmCX7jB4zE2gwZR4RiTINPApJ2qek2aci9qrt73Kv74IbUcHMOg1UY4y6yJ
         u+hBuy7qazXrImxXnvU+/oJ7Au16sLkFLTaCsO4fdO0RfeLZhYFCF8mC01RBmYsch/P1
         Pq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717422821; x=1718027621;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D113Qv+a/qRkarYonAqzqUl+SWbIin+fbm/bKeRDIK8=;
        b=ilM6420ERPbgSRKSn7+30YCDIjiSvYMyyn/I+cTSH7nJataBExzIDNjGJx7hwhtbRD
         2FJYA2ehu70c60v93yqALtHFpC7O6TRtSeS4eGqbyk0nKJQ8Ggk1kcR4fjg3SzqNLUJc
         bK6rVzwvXhf9iYXikLkeevVepAG7KHMudzVkvxOHZxPvKDP2vXItLq+5R/CH5ABe1pMo
         87tHgAt+nB8zJnskLTsfwXHJUz+1bEnE14zDrOJlMxnU0bo9W6XBYjsSPBeGaR/Wb8xe
         hGc8c7xChvN9yquXCGHOkCbZnjhTW+3aU1oXqboTVFfL+8oOwizJObWWCkf668OGo4SQ
         pOVA==
X-Forwarded-Encrypted: i=1; AJvYcCX+zxEMHiFGZDM0hxHsEZCRX3gEApYe6rkw2ht01vPvMtyT42VVZJ8LuNll69vP1TlLR1wNl+VB5JKZYokfrE4p6TnhH/Qeu0w=
X-Gm-Message-State: AOJu0YxlGtsOCDcLTgXW9Jqgi0+CqB1C0A4qUftNw2q9zwhkXZhP6IIM
	V8y/psfJKOFhDB9l2VjThu58mcEJXFjDY9lxdnIv4+q4q9wgSBFWT4nzbUMP
X-Google-Smtp-Source: AGHT+IHAD3kEILr7GmHGpHaZYskfMFWYFOrmkaK8gpZF9h60l85zsh5nMrtlkYSsIY08hUN5eQMYvg==
X-Received: by 2002:a50:954a:0:b0:578:649c:9e3d with SMTP id 4fb4d7f45d1cf-57a3634798amr6072058a12.9.1717422820254;
        Mon, 03 Jun 2024 06:53:40 -0700 (PDT)
Received: from [192.168.42.59] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31be4e36sm5289331a12.53.2024.06.03.06.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 06:53:40 -0700 (PDT)
Message-ID: <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
Date: Mon, 3 Jun 2024 14:53:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/24 16:23, Jens Axboe wrote:
> Hi,
> 
> For v1 and replies to that and tons of perf measurements, go here:

I'd really prefer the task_work version rather than carving
yet another path specific to msg_ring. Perf might sounds better,
but it's duplicating wake up paths, not integrated with batch
waiting, not clear how affects different workloads with target
locking and would work weird in terms of ordering.

If the swing back is that expensive, another option is to
allocate a new request and let the target ring to deallocate
it once the message is delivered (similar to that overflow
entry).


> https://lore.kernel.org/io-uring/3d553205-0fe2-482e-8d4c-a4a1ad278893@kernel.dk/T/#m12f44c0a9ee40a59b0dcc226e22a0d031903aa73
> 
> as I won't duplicate them in here. Performance has been improved since
> v1 as well, as the slab accounting is gone and we now rely soly on
> the completion_lock on the issuer side.
> 
> Changes since v1:
> - Change commit messages to reflect it's DEFER_TASKRUN, not SINGLE_ISSUER
> - Get rid of the need to double lock on the target uring_lock
> - Relax the check for needing remote posting, and then finally kill it
> - Unify it across ring types
> - Kill (now) unused callback_head in io_msg
> - Add overflow caching to avoid __GFP_ACCOUNT overhead
> - Rebase on current git master with 6.9 and 6.10 fixes pulled in
> 

-- 
Pavel Begunkov

