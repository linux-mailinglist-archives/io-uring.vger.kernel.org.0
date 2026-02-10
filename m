Return-Path: <io-uring+bounces-12140-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WASaImMki2lyQQAAu9opvQ
	(envelope-from <io-uring+bounces-12140-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 13:28:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F0711ACD7
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 13:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DF43305E989
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 12:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF580329368;
	Tue, 10 Feb 2026 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DeRpSd1Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA1328B7F
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726392; cv=none; b=dIJYGqa+DoCkbu4DGo30tOR/9RNswiYkPPXmBsEQnDzirp+2y3SAdKxsE2xQlvD+fKeNojfSFs3fPwgtJyAukRLLE0Ah0egVMEBYY+Q01sgQkjs2gLZuqgvBJTuTfMt6djqrRpkBCE4PMSozlL/TJwpBSBvq26yi0RZwfNws6hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726392; c=relaxed/simple;
	bh=M8A72hjnMo4By0Amaxw5oT1voUJxJgBK1dG1YcYC5Yw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gEq4V3uIT+mBIModbmsHgB1odtj7R1w1rphbDJAMskqz594OoAhYyma0NnM5tgMb1DyNAMgxEyJf5KcBBtiziZqxHi8XT0l/UtcY8N6y+7eoymilQsRlq5lgSgM8HF7SMATwJ8lqJb6Z+eOUp7YMqoNDhBkXZxW+01hNr34i+E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DeRpSd1Z; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d19d3c7208so446429a34.0
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 04:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770726390; x=1771331190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wA4pEtJuF31ZmgppCwcr3nUZNJAl3ymfiu+rrUvBGC8=;
        b=DeRpSd1ZynOWyivdetP8C41rZDmdPPbTS95XmipW7YtDXOzR0tw0pDUagbO73S9zaO
         f9/eStmTp3FCoO6e9k/utI/hMecLv5RQH5GrwTV8LLhlfBvQjrQFfjuRLoQz+GxCOYCy
         70Q/yDAVXur9165kxAbrjXSoLPzCtiF3QZxDDq1esPRd1I+o4+ePBB/AZBQA/HEChTsC
         7aF2yJd+W351gWp1/oP1BREJ3zK447xHxl+bqLwWBKX+gn92jB8Ue8VmdnNYRi/qwMGt
         pAvLLRpLqGLCPNjFf+i+uwlDYTK2vzdKlv1zz39rnfhyBXynqr7Bc7k096U3T45Ini3V
         5RcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770726390; x=1771331190;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wA4pEtJuF31ZmgppCwcr3nUZNJAl3ymfiu+rrUvBGC8=;
        b=Ous1PtYSXC5cRWJFn35Qooog20xNaoZR1T6uG8CESy539TsyS24NMlSVFh8tIhwbhz
         Xyl4lo0VO4BHQ2T8odH5cYLjUGj9IdrJeWtBk3BkuenCfnoEgC2ygUZbaJIS/lOQddWJ
         mqYP49sllgteDIULwRRAG2e0pzqq64BrQJIIhqwsGmWALA48uw80W0pCtW5vnoc0Nt0q
         6rtxiHHV+7z5FNo3pturirkpYHowpMHTuPBAVaNin7ErqijFZOHAUzwiVQwb2We1LH+x
         y8nmV0R8Pyh+20HWa2+E0LNRijwLxBWiNVVO5iADoNreRPeg6EEmSRLPag7dqLpDGTBi
         qSGA==
X-Gm-Message-State: AOJu0Yz41+G5VvYf8LRPcFWXnOoOIklex1MIEbKj5WuXiR0A6Y3bAjOs
	IE1RgQvrwlkHezWil2y/55772a0spFNF+FFP7ZasNGeeJCi5do2id8h6IJepKy8ysmrMedColHq
	z7wtZVYw=
X-Gm-Gg: AZuq6aLbTlNB3TbyNV2xOudzbyvwWybWJx2oeoHRjp/T1gjq+hRyeHXHSjz5wYsle6j
	FHTEEOPAyPOJBmSEbBZeHW8E1kZp9GzrWyMXtRZxQSjy/wTfiZdTmh5SaC6kJioZsK0TbLWHrn2
	ZFH1ad+LXD8aLUKnSqL48ApnKlfkmsMln14oLODM9ZBf13zjhIT8YtVj8+my0c2klZim3aM83rC
	lAt5EOK3GcoNSOHTbMNmhaAQIrpMDyUJn43jxC6utm3nE96/z8Ae/pvBSKsWeiw/Q4oudqWyNB/
	cXFVAMpRITCffHWrPt4DBPVmRQBV0YtItsWRt91s6S9h4/3RBA2iNB2sQyXMQu3fKg2biUq0zGa
	8pOih0cToAl4U6AKQGxOq5Z9v/0gfb8RqFkUtUeD2sRNLmMZhROE8nDKl4vRcdnXrBqdgUyvlHN
	+O6Mmfy+aAjxs83Hzy0SADu6DIKLoWomS2BVuFfKkW6zIsednOngPiUrucaZgKI3Bw0hPga0CZ5
	nMw
X-Received: by 2002:a05:6830:6a14:b0:7c5:2dbf:4a7d with SMTP id 46e09a7af769-7d46468a0d1mr6466547a34.31.1770726390428;
        Tue, 10 Feb 2026 04:26:30 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d46470dab9sm10115924a34.10.2026.02.10.04.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 04:26:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b2fa5a88797fc54bc365f88f4884a845b0a16530.1770646345.git.asml.silence@gmail.com>
References: <b2fa5a88797fc54bc365f88f4884a845b0a16530.1770646345.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: replace reg buffer bit field with flags
Message-Id: <177072638918.481609.10158846912245144904.b4-ty@kernel.dk>
Date: Tue, 10 Feb 2026 05:26:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12140-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: E2F0711ACD7
X-Rspamd-Action: no action


On Mon, 09 Feb 2026 14:31:22 +0000, Pavel Begunkov wrote:
> I'll need a flag in the registered buffer struct for dmabuf work, and
> it'll be more convenient to have a flags field rather than bit fields,
> especially for io_mapped_ubuf initialisation.
> 
> We might want to add more flags in the future as well. For example, it
> might be useful for debugging and potentially optimisations to split out
> a flag indicating the shape of the buffer to gate iov_iter_advance()
> walks vs bit/mask arithmetics. It can also be combined with the
> direction mask field.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: replace reg buffer bit field with flags
      commit: 0efc331d78b043b9d8477c64e279058062d36a0b

Best regards,
-- 
Jens Axboe




