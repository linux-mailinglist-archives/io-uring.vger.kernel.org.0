Return-Path: <io-uring+bounces-5669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 659E8A01516
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 14:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2F0D18842FC
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 13:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF57518D63E;
	Sat,  4 Jan 2025 13:55:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAAF2BCF5;
	Sat,  4 Jan 2025 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735998919; cv=none; b=k8IygaA7hr8wJm/fwgdncXmUu1+SjvM86oeYb7yKdZVhJi5TzfX4W1LWQIcc9Ccf+Lrr7B6Bi8n8nqy+K5rF7k49avwq8cYwF1pd8aJ+G3ti74TmCB3nHqCzECMGZdCrbIg5Y51vZLCINfdeUaSMSxKioDx45K5qVCgopdWR7Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735998919; c=relaxed/simple;
	bh=IGk95VCEudAv4vDRoF2lx16EXGgTwg5PcB2eBxilmvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aYx7mndz+ymnERIOsZq9Osr8H4jKeDcRm5sLnLiaN8AeJDQX1A/oA/IRiK0dSK0TnRmVvlUrkywSRPMJy2IsHiF7cdvr0oxGtzmID7BuzLXbJUKUTN6cfgj9qJUd5Oq3bT1MSjhNkzR3t9m7vHjZwvm7XAbhDPpKIxuFioAfcmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 504Dt7qu096100;
	Sat, 4 Jan 2025 22:55:07 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 504Dt78i096090
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 4 Jan 2025 22:55:07 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c786e645-7fd6-4f62-9f9c-56e3434f6e58@I-love.SAKURA.ne.jp>
Date: Sat, 4 Jan 2025 22:55:05 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in percpu_ref_put_many
To: syzbot <syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6769bf7b.050a0220.226966.0041.GAE@google.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <6769bf7b.050a0220.226966.0041.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav302.rs.sakura.ne.jp
X-Virus-Status: clean

#syz dup: general protection fault in account_kernel_stack (3)


