Return-Path: <io-uring+bounces-12230-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GhgeC0ZZkmmUtQEAu9opvQ
	(envelope-from <io-uring+bounces-12230-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:39:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF401401ED
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4DE4F30073E7
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E4A259CB6;
	Sun, 15 Feb 2026 23:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSB/EtJ/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05E126E6FA
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 23:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771198785; cv=none; b=iEq0tbOL8Ecmpd3pOEDYqsUl7/jXLVn2tKjPxm1V5sYlxt21plnZSD+kVFxo/GqeHykoYyYUQUTSLKKzlc/WkLO7QidGfP+HHGUkBKT0U8hDv3CBVpVf9LRwA72Pg0fWRzFAMK5xNryxs32GlCXlF5eNJJjX4SZK81qOxiad+lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771198785; c=relaxed/simple;
	bh=l4fTbSeylIY5PM1X0ImOF92jO1qRCLKkQOiKpbNJWhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DcRXag+Mjxyjbu0xKP7l2K8onn2euSmZ22JBOMcteERK0IPiFWzZoyAgTdC6BNN9qdbuCj/n3TFJp3yNFo/CAalqUGfYmN74QyruHy3eVwzaRftwO880T3ZqWlP8Uh9cg8JeMedzcuXf0nEv13BJbMZ8hwj6qo+/RhA7db/a+Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSB/EtJ/; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836d4c26d3so19651325e9.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 15:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771198782; x=1771803582; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n4ZvTPivLvH9fhB0u3hORbLDzgkprrFDPHoQPST82xc=;
        b=ZSB/EtJ/N/qoWb4sBZ+5sl++59+RUrHht3ZFR/43IywHqFDvIPqyS24JTpL0Dy8LdF
         SBANzjtxudlaooxgyVeZy6ZYh+tW3YnPqxIlyeUmIiTPauljMJAXHtlE4+CuBvnOIER/
         9sW4OutME571t7ejTN4pumtQVLVwK2s/EgylWdh6lDC5+GYn1EtNXxe79ns7A+VkMra9
         UERFQkcB0ef/PPbaEF3h0TvFwsDiU/xLhVdlISclB9L62BJCKObKEkWQzDIxbDZ6YgDz
         P08f6Vk1bP3CWi+2iBUfSa6CLcYizt9mJHitFRoHC5z060zHPbJc1siMr+BPaJ+Ui4qn
         P/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771198782; x=1771803582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n4ZvTPivLvH9fhB0u3hORbLDzgkprrFDPHoQPST82xc=;
        b=NjqZ2vDZ5iTqfbmcefUCPuW+77g5+ABdkkY9rieNmQw9CNYMvHwcWnyCmUAIvYoXlF
         /AzeFbeaOgsAKJDkTUuppD3L9uiYY2LK58pkgu/ZLevJbAp+eZtgJ2z8OA/Z4aY+JFrY
         AMRftg8SCQrAPWuD/aK4E8U8qYEHKSjEsmbGCC3seZqzqFOHbpnLZpEcJUBzaNjcfW3m
         gVhxDREmLVSJDRLtctmtRahdTIgrnQCZu5RYHIZ6ATU2JWTDo+xg3IMkzbgeEYsuCXwx
         dDIinMgdhFl5IWqsSzwCwa9GiIRQXCN52okvNcXBXxNPp4L8XFH8p9FE1kE43o4ud2VZ
         CuEg==
X-Forwarded-Encrypted: i=1; AJvYcCV2yCyN+9Ue4PjkHjoMlYjirdFDD9CYxK0hyN5WPEXKLnLbUYsbVSNF6OUq+sX1Z4HP8dJQbdL9mQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg6ZMv48GaSG7H1WmgjOzbKXWKprjsU1YYrddCD8r8DBm2OD7A
	/Sm/O6BL5gWfCgn/wfpInQV5Xj7swcw5BTkXqhp84Oeq3YgWFRF4HdAF
X-Gm-Gg: AZuq6aKeiy0PQAnLrZB1C4nuYfM7WLp2SQTq+BRhLfOblbj46Pt4agzB7A+Y7XsmOFF
	PQ5A8uLTI5qOXIU9J31ZYOG+GiLDq3tgQZLHZuVeebnT1Sa9RXoc7Qf8rPFGYjpZEr6S0MHS6+Y
	OQ+HQmuLwnFFNiKmm0RJKStYRFdCxfzBdJmXYXnTycpi7ccl1lMaVHkPE++LF0oFPpFxGPjUtzN
	Kv+wKuq506KwmH82wrkWgUCiy/wXYPm75t4Bg37eFH0RB5MIA78ji5NHh8BowoeIHQnWKasvkP0
	2vtEV9qXUJncdWnYQyVSkWZMvdQTQ/8ySDmifYaEGY6Q+lRfJVdg5agKbbsZD614yYVw1m8gvae
	rPPMFa43MCInDJV7SHpOBMK5Lg6o62N9veWyNdqb+EAOa6OZxTDV4k3yTBTZODvEKevOVBqTVeu
	Ux4pyqMCA049OAdwjINqlBIVnosDayPuLQuZ1BelzMgZPrhpjgHSv4HvvYvT9P+WifKlSUdjyjL
	PSiK3Qgq8Ve4FAuj66bgtld8ceaQW1ude6JpcRWKCucdlBMZxEY1S0Rp/d0pK8krAt5H5Qs0XX1
	pw==
X-Received: by 2002:a05:600c:6808:b0:483:2c98:4368 with SMTP id 5b1f17b1804b1-48373a3e755mr151719285e9.18.1771198781870;
        Sun, 15 Feb 2026 15:39:41 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5e11f5sm424994745e9.4.2026.02.15.15.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 15:39:41 -0800 (PST)
Message-ID: <c8c715e9-1aa3-48d1-b080-8844be893571@gmail.com>
Date: Sun, 15 Feb 2026 23:39:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove unneeded io_send_zc accounting
To: Dylan Yudaken <dyudaken@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org
References: <20260215231523.308665-1-dyudaken@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260215231523.308665-1-dyudaken@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12230-lists,io-uring=lfdr.de];
	URIBL_MULTI_FAIL(0.00)[tor.lore.kernel.org:server fail];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8BF401401ED
X-Rspamd-Action: no action

On 2/15/26 23:15, Dylan Yudaken wrote:
> zc->len and zc->buf are not actually used once you get to the retry
> stage. The buffer remains in kmsg->msg.msg_iter, which is setup in
> io_send_setup.
> Note: it still seems needed in io_send due to io_send_select_buffer
> needing it (for the len parameter).
> 
> Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
> ---
> Hi,
> 
> I'm reasonably sure this is correct - but I think Pavel might want to
> double check that I did not miss anything. The tests seem to pass with no
> changes.

Looks good, I'll have a look tomorrow

-- 
Pavel Begunkov


