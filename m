Return-Path: <io-uring+bounces-3173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88972976E91
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:19:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11053B22EAF
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D8A13DB88;
	Thu, 12 Sep 2024 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l96pUHJS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC8E13D625;
	Thu, 12 Sep 2024 16:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157969; cv=none; b=Bu84blxS8WSYyNMzW0Bo0NSwVMct6SWTg5r4+DACqieWy942tKb9TNXQoo2hAcotTp1i+gwyhVGkt8GwhhnbRBxeWBYUzSu6g7Vw7PSHu5e2b+XoIhiP+UOPLX2RV0QUKDlFZb2zBIIpGLHYTfbwwF4C7l5LoDGf4NAzBGviDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157969; c=relaxed/simple;
	bh=QqCNOnipjCotgLqoapxGGKKauCuAdodq2IYjSv3Y9tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ko9GqweRH+ITIOt371pwBtDap07BykD4CpuRImnMNKi5OhfIVtDJcjLbhsNAosnyjtVwfZV8aVfdc11tXZbX0YS0+TCvl3Cd/emQOegjHoLwcaCX8H7w1dM2fEH5Z5tgSdAqBVgLWrFZQi0ccV1SD/8bynAkW10+WgtuJwXcJEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l96pUHJS; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-374d29ad870so854164f8f.3;
        Thu, 12 Sep 2024 09:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726157966; x=1726762766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5heCI+47xmlupHUQF1kgwwyCSmQenWvUXPcC78p5pdc=;
        b=l96pUHJSFswk/IZD69SuagSLKts/fxIhsOlN2eT1llZB34wizAaH1dkYumiU/0+50K
         YdgGejxE22dC06OMKIbw1gsleGPCVykTQw6497v/8FcL1sR/CAcpp/g1RuFJ3hvEo1w2
         ayQPJNE2MTMmhmPCpYQKQ3oNtif58NCgD08kp/vmELJNIoc0/13n5HuQkCEPpLI6B4Bc
         K3Bm7dFNTeB/JUhBaVnoJEoRwAJYfE1V453zDgF3td10VTDSWq11jalRWt4qsQaGrFlL
         VEjTbQ40+esWbaRApMN7R/eJB4i2+8VpUtx5zzSClfqY2XhPGpW+SBICKLXKR045rexH
         Q16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157966; x=1726762766;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5heCI+47xmlupHUQF1kgwwyCSmQenWvUXPcC78p5pdc=;
        b=tUQ1u5AlZRnuGOgMgmmRdBONeD/cqD8f/0kVGAT8YFWz8oc2C8gulsPwwFL0pZMJ6x
         R9w8LAB9whGYMm4t1e+hHm3rwkcOBSJXWlRWWn9ohwXOmkmbtQ7XthaRwBOWlSmSvvoU
         V47Bg4vhq+NfJDh0twzOsgmuE/LlF7MN3Armp3tsFhlLD9HNTNMLLFQXDtLcQBDHWRyb
         LIb9z/NrQ6W+J1/221gIRXSHVCoFqA0v0RGAtDsgerc3MEo47/B7xFueCt+f/F0O462U
         3LNICRAyZjeMl5NwRx8h9547xJeWywkSk1ColitQ03C72hQTTHfzk1GB+Zn52daZfr1D
         Z35g==
X-Forwarded-Encrypted: i=1; AJvYcCUfzpd4QI/RlYNnhyfi4DGOZYGOeW15/9JsCJ59q0raEv++aJMvvgPY/ITSDh4ne6TM+IiLBL2KhQK7wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFwLW0lG+OBvXiGVyQCgiBGdAEDPMovgyILKKknlcKYg4nE3W0
	HEbe4C0PzfY/3oKhglbh38J+qkhLUbrMrI6DY8Zb91tQiqZvczFl
X-Google-Smtp-Source: AGHT+IFvm2FOZl5cxdrq8pfCTuBirVZOyvXOWUIy89T3v/6lVbbJuXfPYO7xnI5fLM+68x9TxMwJ7Q==
X-Received: by 2002:a05:6000:cca:b0:371:9377:975f with SMTP id ffacd0b85a97d-378c2d02124mr1870902f8f.25.1726157965515;
        Thu, 12 Sep 2024 09:19:25 -0700 (PDT)
Received: from [192.168.42.65] ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb44473sm177952655e9.26.2024.09.12.09.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:19:25 -0700 (PDT)
Message-ID: <7bba622a-b530-4f00-8dad-78504e51737b@gmail.com>
Date: Thu, 12 Sep 2024 17:19:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/8] block: implement async io_uring discard cmd
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 Conrad Meyer <conradmeyer@meta.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <2b5210443e4fa0257934f73dfafcc18a77cd0e09.1726072086.git.asml.silence@gmail.com>
 <ZuK02DNxedLnmL9j@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZuK02DNxedLnmL9j@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 10:31, Christoph Hellwig wrote:
>> + * io_uring block file commands, see IORING_OP_URING_CMD.
>> + * It's a different number space from ioctl(), reuse the block's code 0x12.
>> + */
>> +#define BLOCK_URING_CMD_DISCARD			_IO(0x12, 0)
> 
> Please just start out at some arbitrary boundary, but don't reuse
> the ioctl code from an ioctl that does something vaguely similar for
> no good reason.

It's a entirely different number space, it shouldn't care about
ioctl numbering. Regardless, BLK* in fs.h start with 93. I don't
even have a clue where is the rest.

Code  Seq#    Include File                           Comments
0x12  all    linux/fs.h                              BLK* ioctls
              linux/blkpg.h

-- 
Pavel Begunkov

