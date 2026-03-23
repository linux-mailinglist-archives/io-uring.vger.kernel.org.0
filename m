Return-Path: <io-uring+bounces-12802-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GaXLR1NwWmhSAQAu9opvQ
	(envelope-from <io-uring+bounces-12802-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 15:24:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D01E62F4658
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 15:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7F35D302FBE6
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 14:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7052C181;
	Mon, 23 Mar 2026 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aZ0nyrmf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE571D63F3
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275658; cv=none; b=iKrS04qMVJJ9bTnNH0O/Fw1Arex+l0E3Iz3HegcW8O/itfDuvcbs7paofTM3Hl5l3CXAHoBJqxpi6JOIy9R5APF+h8LyqlEiXh1+daXOqc7e9ncVFlmsiVMvj222IEx+YqK6N0jU1lJ0IuZ8VOj3Tx6EkgcGhJU+yfORAdYjjDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275658; c=relaxed/simple;
	bh=zASd+EOD13ftIhyXflTViXMTNoBklIHpY3QeXreZJdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AqtOTLRahKi1QGk9Y7YAXkBKaKFiQm4u+T7b7SlkxVlL9hBDuFs58cNi0lrxrKhC0aYwKXgMzuzxF/c/w5zCo6YBJl6bfhul1y/2tM/vWjiPkXfemhwDIlP5znf8BaLNnDI8sPDTH+Xqrt1YoL3X99eh0PxoY4+Ab0Rgi+GTGCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aZ0nyrmf; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-46701f2077cso3870677b6e.0
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 07:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774275655; x=1774880455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dEq1d5NT4C1cBdRHUylNiTgQKOSaQf+PeJbEdc2Od9I=;
        b=aZ0nyrmf1eOBguV+l7xSHrXEiVYNi1mlCoj1X/HehYuH8cmnnWUa1IlKRvfwuVKLyD
         aS9gaB86VJTtLyUTYnD1r48iBVaPhpnnyvoLPzFMB1WnvNVZ1oRXisYep4uSOH0dk3K4
         FFPmSrn8B97wbFk8NsqelzgE4DXt8ygobirx5kuQIx9t24/zY4Klaa7ZV5+lXrDjCsMn
         Bjowt3DgIh7RpUyQBvTU87opCZQY88pLKf5ICRTTeMwxYpflCFaxDj/7Bh2G9+07v3Yr
         26zA6BI48wSyMGsUt1Z2HGb8qnCEmbFhcVoyhfZRshYcW+Zzj96nQIRB3B71ssfwSp8X
         jIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774275655; x=1774880455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEq1d5NT4C1cBdRHUylNiTgQKOSaQf+PeJbEdc2Od9I=;
        b=odtQ/39h14DgHU1a3AXbW4rrk0t82i52Z+n6H9pWR3rudxXPkX/SWq6Ks/7NzSUrPf
         YsGtF36ad+sSsz6up2BRZHBtAgd2pTYYbgqF8P8XXjG0TkJw3lJp+SmLl5vp9/JHUvwF
         /UqcBrKo5wuWwWaa6Erw9FgrvGFGnkAt8R11tpKE+9hCMDBIsVHe2yBiiAvcXNOkijXy
         CRubz4UYfoPe3tOCbBxbTs5Ib4GiIN58yk6OJiDNYe91/uEMdUQO23gelJbtDRSJjs0b
         /ZnAv0EzFJslVIhbVrzWRWRcNLWad1b1Gov4f+t7Q+OTuZUPE4utmM2rgyPP/3whE6/8
         G9BA==
X-Gm-Message-State: AOJu0YwauQesFSzS6+DPQW//ceZPGJYRZO5vkTCD6i2/EszE1ljAiZuN
	qVP1RgxbeLyWVa6c8hupUPvOM3LFSmtsLbbUsFQhp4mC+vfyiCVHbQFZ9EWVFRJiKI8=
X-Gm-Gg: ATEYQzx14vxFR/Yq6iMq6GPAlDSonUS/cz5CD0kndWAe2zXu7BaZVViDI2Hj7xjAIQq
	7F+liAfJv5MR2XhM1Qq9pyG/r+pKagnES8dmbRXJJtNjw45A0kSMQKtezLXeIZBnE/iS50evQBK
	CEjUcyr1bxs9u5of/i+vDkRFR9xmg4cWv0tmumNhFfYW3E4o7Bn5JNzUcjYYieSoVA7o6jGMZTK
	6MlL4hdXbDjS2KDFzQQYvqtW7Mkq5zkwl8lvmw+iG0rHOnXfgVP4QzfhxL+vByn2r7xfyc97sGf
	fR+14CnKRBWvkGpPHoBJtjHqyOmRoD+fGTe++wJhKlcLspJKj+qEX0GJDZenI5idpYrJFbRpFge
	H03oAGYjbO4HhKOzJIVU4RpyC2X2i+6UJ6GOn6VNyhmjgqD9h79IZwcjam0115SC6/jzUhgRcpz
	pIq7Mr33x80FqIhY+j8INDnOG68YIBJHdzq2IiDsczth2wdADie24gFW1iJ7UHE9HBFwhbx2MVC
	E9KynOmVw==
X-Received: by 2002:a05:6808:17a5:b0:468:1f2:5336 with SMTP id 5614622812f47-46801f2801fmr4546884b6e.28.1774275655162;
        Mon, 23 Mar 2026 07:20:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c148a90f3sm10715182fac.1.2026.03.23.07.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 07:20:54 -0700 (PDT)
Message-ID: <4970a06b-95f5-45d7-86dd-1055c1811ed6@kernel.dk>
Date: Mon, 23 Mar 2026 08:20:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] fs: Export new helper do_replace_fd_locked()
To: Christian Brauner <brauner@kernel.org>,
 Daniele Di Proietto <daniele.di.proietto@gmail.com>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
References: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
 <20260321232142.911280-4-daniele.di.proietto@gmail.com>
 <20260323-kocht-meisennest-ac89063f104f@brauner>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260323-kocht-meisennest-ac89063f104f@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmail.com,zeniv.linux.org.uk,suse.cz];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12802-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D01E62F4658
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/23/26 6:00 AM, Christian Brauner wrote:
> On Sat, Mar 21, 2026 at 11:21:41PM +0000, Daniele Di Proietto wrote:
>> This is a new helper that installs a new file in a specific fd number
>> and returns the previous file that was there. It requires holding the
>> files_lock.
>>
>> In order to keep ksys_dup3() simple, this commit introduces a new
>> static do_dup3() helper.
>>
>> It's going to be used in a future commit.
>>
>> Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
>> ---
> 
> I think this spaghetti here is really not acceptable and the export of
> do_replace_fd_locked() is really ugly. Please try and come up with a
> solution where you modify e.g. replace_fd() that does like 90% of what
> you want minues that "needs async" shortcut you have.

Fully agree.

-- 
Jens Axboe

