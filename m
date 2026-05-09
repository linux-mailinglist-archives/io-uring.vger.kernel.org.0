Return-Path: <io-uring+bounces-13261-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id NTv8FAc+/2lU3wAAu9opvQ
	(envelope-from <io-uring+bounces-13261-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 09 May 2026 16:00:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F99A4FFF48
	for <lists+io-uring@lfdr.de>; Sat, 09 May 2026 16:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A41183002933
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2026 14:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA511EFFB7;
	Sat,  9 May 2026 14:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0ltjihFY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D41175A71
	for <io-uring@vger.kernel.org>; Sat,  9 May 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778335231; cv=none; b=uOr5W80KfBmd6oR0y1YJv1SRzlqnlqTVWcsDkYaXt0pMvNkwxsYuNNGTCzFcswZmhxSrWRrU+8sLQSRcv0VbZLJ0Z5fViKJ5e5Cu81b2XFx8Oxioe3HkaK0MybIyoTAWnKym3W6wFlHNL6zIaWtJCpDRhGEDNuF8OgvwhCb8F/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778335231; c=relaxed/simple;
	bh=PsCo0lcZaJjSRt1iOB5CpCPk5Xrgp/pC517ZwPqO5YU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QX9kOsIVa3O0AZOeFdWApReaDGKv51MqxqMDb79lIS2y1CWt/hpdjsvenWFpQAKumflOckQdpbgorzMqItWyYMqHBO8bHNICfIyFTEYpkz9PwybScrIpnOEVY382/G2xg7LYDXnNdgPFue8fK6v5L9Fl8/yUMN3MXJr2j+vr2tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0ltjihFY; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-479e4835e26so1735498b6e.3
        for <io-uring@vger.kernel.org>; Sat, 09 May 2026 07:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778335229; x=1778940029; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7Mj0WiH8FfalD+QUo8FVNix1iZLDEqEjcJ7lZe/XXM=;
        b=0ltjihFYMOtzTiA8FDoEr48ldNRO+08wivcmjHPKuBV4pLaqs+9NgB3CHY16BkKrMI
         WAGeNij5ZwW3bC3nBOPT5pqCrRPjFt59OuMUnYHnfD2dpfdSsNc+a3DMdBxvjVhpvxwj
         TS24jJvlQzK6rZdcQz4yd04UJno12xN9GldAmpIrBbo6D9q19JWLmtcLOt/2nZMZTrXf
         1jjSGkP7R4h4QxIai45cyNx2Aiv0Rcia2ZLXUtJUNc6MTXAppYspjiuw0I82CM66O33L
         Za9uY5KXV/bBn5I9nnqJIdqhoMkXCevlpG0gFV5mQlcPPZfL6gGzgpCt6qws8dXw+s9M
         cBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778335229; x=1778940029;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7Mj0WiH8FfalD+QUo8FVNix1iZLDEqEjcJ7lZe/XXM=;
        b=RuO2GFtrYlp5GYL48CfEGEkWrFsPkFQNAcd8lN80filE1rDRrgLqChplMQ4wS3/EVd
         RC6uTMl34z4wvci1mO7GDUC9imHsWT9dwpRt+Lnbje3anz40hWUtn+eDacg6kMbHv5sX
         TlpTVKF5DD8j4rwNSNtRAkhSeBSrxvDuzkTpCpEPI4Jqa1WuNoEq52GbcVwSAiek59Iw
         A7yjcxPlgoYcYKdGUSQmr6VqstflSmZKozJBrTA6x9adjMWganTK8mJGo5+dnkSmPCFD
         g6KXNzlSOuiLF2+YW7P2FFaICpK+p0tPrGuNnYUvA6aAyuPLDyK2s6bjbIm7zaSydUeO
         o3rw==
X-Forwarded-Encrypted: i=1; AFNElJ/TLb69Q0jgnW/i06CjB+GKul06cepfC4lPvyUQ79qUu1lfJzDBSdF57goYpqi9YRYubddNqtiU8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyzqtD3qSP7eSSqCUCHcgV3zyvLM+LYsmHP9M/rBZilVILfcTSt
	3ERNsP6oen4n9ay3MnYKYQNyXNKk0l/xjSUg6yE7g0CoyZIg90PnL9C1Goulr84N09o=
X-Gm-Gg: Acq92OFft2kE9ftQ7lVdHLt+4hqEu5loW6Uk4mRwG5ZGXwG9VvidW783aEj/dsXlFfK
	v8ESVYTsxPuepy+ffTPUqqnAXnkt3aOrgNTfFOCqLBPbJyIfdA+SML+SwatCDOmMR/xR6fTNEeZ
	/MEOQ+qUsEeP9wSv6DDmk203ts+eG9ctgQfEnT5/GWCRw0W16w4pgtUEMa6wGXQGDqkvzTuOITh
	3+QF6TlwwFLpyQeCPnOcGWuRZtW8n3NdnSSFtDBw9XnaC/GFW1JxwSDAMVdg+BQkuiuuneKEJ56
	7JkXe+eFoLHT8DTJyYh0tt8gQaZQd2irVaurybEN6CixxBUEkedvoIy01SjIzA0djFRimEj0ypa
	eX65MNESjyPqTOQ1kini8N6qBpMbyDwxBJ0ZbQ7cvlvdc8vqOIefC/Pk9HT9pboL2hBbghNq88i
	r12V+RLhOM4qTq3L1jV/HNspt/OBtmEHU1bK4dPP7lvFgrz2ZqOUgF39AWf5FcEE4szv0YZsZBi
	v/pt0SUJEq5lj2YmPYN
X-Received: by 2002:a05:6809:112:20b0:482:4dbd:4fde with SMTP id 5614622812f47-4824dbd7b21mr838264b6e.19.1778335228772;
        Sat, 09 May 2026 07:00:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76985f8fsm16666439b6e.14.2026.05.09.07.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2026 07:00:28 -0700 (PDT)
Message-ID: <1fbe6348-581d-44c5-b1ff-966a68a9c507@kernel.dk>
Date: Sat, 9 May 2026 08:00:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question: io_uring SQPOLL fdinfo prints host PID across pid_ns?
To: Xie Maoyi <maoyi.xie@ntu.edu.sg>, Pavel Begunkov
 <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
 <io-uring@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYZPR01MB6758E1C56BE8616027964BE8DC3D2@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <TYZPR01MB6758E1C56BE8616027964BE8DC3D2@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2F99A4FFF48
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13261-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[ntu.edu.sg,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/8/26 2:34 AM, Xie Maoyi wrote:
> Hi Jens, Pavel,
> 
> While testing io_uring with the SQPOLL setup flag from inside an
> unprivileged user_ns + pid_ns, I noticed that
> /proc/<pid>/fdinfo/<ring> prints the SQPOLL kthread's host
> (init_pid_ns) PID rather than the kthread's PID as seen from the
> caller's pid_ns. I'm not sure whether this is intended behaviour
> or a bug worth fixing, and would appreciate your view before
> sending a patch.
> 
> Reproduction (KASAN, mainline 7.0): a process unshares CLONE_NEWUSER
> | CLONE_NEWPID | CLONE_NEWNS, mounts a private /proc, and a
> grandchild (PID 1 in the new pid_ns) opens an io_uring ring with
> IORING_SETUP_SQPOLL. Inside the new pid_ns:
> 
>   /proc/self/task contains {1, 2}     # SQPOLL kthread is PID 2
>   /proc/self/fdinfo/<ring>:
>     SqThread:  356                    # init_pid_ns view (host PID)
> 
> After applying a candidate fix that translates sq->task_pid
> through task_pid_nr_ns() against the inode's pid_ns (mirroring
> pidfd_show_fdinfo() in kernel/pid.c), the same PoC prints:
> 
>   SqThread:  2                        # caller's pid_ns view
> 
> Is this expected behaviour, or worth fixing? If a fix would be
> welcome, I have a 2+/1- patch in io_uring/fdinfo.c that's
> checkpatch-clean and verified pre/post on a KASAN VM. Happy to
> send the patch and the full PoC if that's useful.

Please send the patch, I do think we should change that.

-- 
Jens Axboe


