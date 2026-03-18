Return-Path: <io-uring+bounces-12741-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLO8IluJumnSXgIAu9opvQ
	(envelope-from <io-uring+bounces-12741-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 12:15:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B1B2BAA47
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 12:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 753C631D6D0A
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 11:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE01E3B2FE8;
	Wed, 18 Mar 2026 11:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiyPGfjM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652CC3BE15D
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 11:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831636; cv=none; b=tw1Hf63svZK/o+wbO93iH6jRL+7UNMoIyEvK4GIvIwzElOo08C9KFKeKoAgNFoenhZa4YjEJEieWm01lo3BTAJTg39egaatCkNW3TKInkhwbK4Q+T9UlZdnActq5pXadaxv6xcZRwOPicGXlTMzSmE36WANchKYmEjE9q8y0NlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831636; c=relaxed/simple;
	bh=NAzQvZljCxN8j9k4fUxGKFciilFjDg69mpMO3HdUlWI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ODxc48vboEATPUbgN9hTLewy5+Rj6RtpCJVYtdOQ3BzFWqNagM9slVZ3at6/J8zzmJsLtI/cpvgoT9ihwODGUGIuBcUxCC0hDoQwd+OVvRoqmoAEDxCOyWlRfJgSOxcKuOqt3Yrw43RVDQzKIZ119XbQvLnr9HQ01tSAjdG65Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KiyPGfjM; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-667acaeae82so1712967a12.3
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 04:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773831629; x=1774436429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ABvSCbQVr4b83qEOAzrT2E+z9+rprhgoQ15uDUwWsmY=;
        b=KiyPGfjM2mceQF3qPCQmaf1/kd1H9DPABTcXwPDrLkcY6TAbeg+/7gITetN9qYWuSG
         EzpAxMJedbm6ZfnwK2iyfBC0gT7O+FoQgdEBaW/5KYqZsjD7UO7j4k1RNCruZt6wYOxb
         wo3/IJQEhQ//lIhEabeVI0dwqdjjVLlS20pE0e6D5EefHZoKEMVxOQtIz8IdRsCVi11w
         6lyn+VDDVul7Kk+tiNru2/lbz7alQqUfyJJ8VD1Edh2KvB6tfFBQ57BcLbyvheDvMQnt
         2cQLQ8b+f/4xs806Wztwq2XGtfuoCNH1PKDy1mry9bhEerohNJqTNTroAFQMkyxhLWxp
         FJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773831629; x=1774436429;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ABvSCbQVr4b83qEOAzrT2E+z9+rprhgoQ15uDUwWsmY=;
        b=il5G65/VL6PSBG1/Ki2hzDUBOVHw7rhHRZdJd8z8Lz46WHPlgATHes7mfkPFPHIQpt
         yMYoj87jGLqpum2dwOHLx67y3ghg8N0iIN0/2IxHOvqjCexOG51PVyA6Tkzmdzk+ubz8
         ff515FGHjhRoL7wMr75zmxijKG8DhclIuE4jpyy7GiGlhBos0KB+1bWNRmbA+X6ipEGN
         0lqT37KutMEmNS1dfnuDOSUEPxeRad/RQ9sx56iZ4Hn+m79GMwtIja+i/+1jwZQEG4n7
         6Nu84UAmv2WkFUciVeojTSlYpV9au6CiVABP664I2sgh8q1otizJL8uv3IwlwbnyHZyQ
         Mctw==
X-Forwarded-Encrypted: i=1; AJvYcCUNs5L4qj4TcbydqtEcuSB4DwK/uR3ktZ2jFUrK3IsG/IJDVcnxMTwlZr6emHE6PBwxi78aYaKpjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxT/0/myGjBHZAZqOxDiJeFnuAREe9r7HVGvsFp62qAsMOENFy1
	3uXd7cmKJKNEbdbEBZHonm8/WckXPxLyy/yNfasmwefm+YZHBNuNBuWi
X-Gm-Gg: ATEYQzwBVl6gIcVGv9DtBsdkvwMamxUR0uBC1lvvUh011S0iaCU2ofVvKhhogbp39cW
	b0mOVNXxvemPXOdtRfMCRg7QtBjsh9r3Una6/w2+HnmBpud/L/J3B7Fgpa3XJbJIz8tvyuSYhw1
	mLUKrafFANA+obi/fHVsKwtdlWiLDbVqqGRS4jNdFUN853jm83Ez6hgwNscpx7SSamurCwN7599
	A8kIaZj5OQVMyhKEprmNr7uFG9x/8yDYGJqk4LW7TTNezVLQplwo6Wx0FuJ3znIjzYXpsUqum6G
	wS3yb4udG9ufVaO4TOiP38eRLWIU7tYYYo8GLgUHy69Xx1itsdAHSxLYG5oHh8/0yn7u3d7GM80
	o8SWXRwFJxhjj92VKUu3CPG1IByBAt2LtulSEAxZiyNkUbs/Dn3YvLYR8ilLIUt2Ry7OpbDITJg
	GTKXnq3s1eNyGDSVpQd04t322G6WSP44yNAt4WuNjACStNDHaRtRagOHsr7ohomeevP5ESUN82x
	zIXSeTpaMuy3D7cWX3sm6r7pnOFGmz599r/I95xkdPoZFIHfKO9MTxe4nM=
X-Received: by 2002:a05:6402:398a:b0:658:3972:3a3d with SMTP id 4fb4d7f45d1cf-667b2ffc300mr1369682a12.15.1773831629293;
        Wed, 18 Mar 2026 04:00:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:e45c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-667b129c63fsm1553510a12.20.2026.03.18.04.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 04:00:28 -0700 (PDT)
Message-ID: <f7f9f2bd-10d7-494c-888e-0de5b91e4fec@gmail.com>
Date: Wed, 18 Mar 2026 11:00:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 1/1] tests: test io_uring bpf ops
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <818dcda223b3288c764367cb0ab8d57c83722d78.1772109275.git.asml.silence@gmail.com>
 <9f08ade1-ca61-4ba3-9d1e-744ea5e8c004@kernel.dk>
Content-Language: en-US
In-Reply-To: <9f08ade1-ca61-4ba3-9d1e-744ea5e8c004@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12741-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 07B1B2BAA47
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/18/26 01:53, Jens Axboe wrote:
> On 2/26/26 5:49 AM, Pavel Begunkov wrote:
>> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
>> a loop, the other copies a file. It needs appropriate tools for bpf and
>> hence is gated on a BPF_TESTS make flag for now.
> 
> None of this ends up getting compiled... Can we add a configure test for
> this too, I suspect most of it should be there already in terms of
> liburing supporting the cbpf filters.

Assuming you mean it's not compiled by default, I can take a look
at getting rid of the make flag.

-- 
Pavel Begunkov


