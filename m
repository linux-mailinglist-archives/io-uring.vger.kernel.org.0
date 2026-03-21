Return-Path: <io-uring+bounces-12774-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NbtDyryvWmMEAMAu9opvQ
	(envelope-from <io-uring+bounces-12774-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 02:19:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2B72E2C42
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 02:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35E9230182A1
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 01:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233D015624B;
	Sat, 21 Mar 2026 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="heITtZXt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDC4946A
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 01:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774055974; cv=pass; b=ojQFXjp5yPG6L8R7wqZGDOKyaRqZCTkcqxEOhMKina0+MkImINT562auhjSkB3ltzReWTX1K8f2FUrrK0tsyiIDdM1kY9oMv59G1YxTyLjxmKV01c1otShVHiiuIajrzIvYpjmh5o5Sr0gA/+NfnzZKJ6hM6nCxM5OQ+LMejvOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774055974; c=relaxed/simple;
	bh=Jqo515c/BgZK/5yBJ9BaW0HLWKPr8AYiv9O9CAKZy8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTkzOWICQvGYzZu7C40eZyvnbMr3Xn8khfzczV0Lc/Mwee3qO/IiS3B6lTbRd2rb6dSJ951weRMY/js3S/B3bmBTUAnSjMLalgvh61dHUpLwX7DAynBviGkCa9czoickHYsqq7YlmahWQKJGJm7j6gRgHg9DNi02Bn1Z6XZMkhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=heITtZXt; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439b9cf8cb5so3256878f8f.0
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 18:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774055971; cv=none;
        d=google.com; s=arc-20240605;
        b=aENuXVf35jexjzLx6ycVwPIEgV5L3NnhjKAG+EcxQyJxW6/yfBJzBJsWlKyac0J74q
         hs1AMOm0WyCxw19dzXlZLPmtXQCuLES0skgZ2SRNAyTF3S/eXp3wQGUxaPp+qvpV57sx
         lEeZEd5LPFCTjIE5yefKnmkZhfVJucHH/PLoYktwFzM7jiLM64dhdrne64VlPReSbC1c
         Z5lYMXjL5WJ0jolRIbKD4fPReFdcpDFmDVBt5PhNNKm7PZCU/dYJMKqqWY1vlZ3rz5bj
         1FBHwYhEZnT3FVoICsjVtRER069gNj11XGjzzqamWrVDDf8WkR/76XWXCFPppTtBvfqD
         sLUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5LziXhS+PKsI2U4E0Nmh6m6esRTglmNzqvqsZu+LVXA=;
        fh=QYHCGiEhE0wFrT2/Sci7otkerKAVucUfHhUjWGnyViE=;
        b=K63RvoypJiBmsrjX7l58JU2uep7ClZz7liVzFI++aE3ScjDvWjgjKzS9DdCylNFeLT
         imIQL/vqozVTWQqEqsuaMynJvhv43IgsDziRxi+j4y9MLh0OFpt0ScvLBc3V3bP7dDQe
         kj+AJ6j9INWoi6IUkLtE16/42R3Z0cOfxG12skHIm6A91YkQJnLfKUDhz3pxaNils/yD
         H1kuTNcR9ADyG3BLQtqJIlDiIk5eOLdYAaqxWbmpqFx9vYui+l5KqcdohZM+75Pa6qSi
         zl1uMp4OH+PAQ4z8H9ATC1KBXDDYmFbMHsuyzlHwXCeTSZuEpK3CW5lb1V6BS78nUvTA
         Tbxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774055971; x=1774660771; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LziXhS+PKsI2U4E0Nmh6m6esRTglmNzqvqsZu+LVXA=;
        b=heITtZXt6dVI/qC6HVd95zt6PYnfcKRWMUNVYSAgwxthqe6AdsIaFbqOofPvK3Vjuk
         r1ovnrn39nuqeg6XyrPtzVDy58edEJ2AGL6ILOyWIzdHtsi0ORB1uK45181ZzxP9mN3z
         D+ETNxHjf0pCnbh0gZ7B+ZDC7DkFu1hGpstKtoUyT6WPpXspDSEyAgf2hYksjiF0a3mc
         DWv7+uOtePvlHt9fs8TC79on0RKQtdj3lsoSXMoLiTLP+s1HBwOvRu7Vp2VfhlEYKHj8
         BArScNAmvWqK78rtsijYUJBbJBAKnNaU8eUyQCueyXVeeVPR/tp9MWZvV6QY49Djrd8N
         zX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774055971; x=1774660771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5LziXhS+PKsI2U4E0Nmh6m6esRTglmNzqvqsZu+LVXA=;
        b=Gv0qMrC3ZYmc55XWciB/su+k1a36uflXAN7XsTuFUVDRaRElF+Nawn4XqQr/bGT/hs
         KcyUBWuhlIhhP1uaBzVI3bW33j/oRqSStMUSojUbmuGg1XMrxdtQr40cf49RdFQ0EtW/
         jMmOFZWptJdJI4zQO2/Z4ypW35SiWO91XjeXt9K8ONjzPEqCp16KWptrzLQxjH/ovjf5
         1AUdzjc7plt7C6hB++QsshfK6K0ARKwijRfP+xfeCpbAsq5ISQEY19XkqzC3XtLfhQW/
         SF6+25bv9DIuMFWHWg8p5OxgmyiSwSOUyHHja4z2CfhPVelnXRnV9LVymP/QzomOvboM
         BH7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNniwiK2oLIGdhrG5Xs4Lo+EZvpHfEMuJ9fzX1Mt0ruknBGA2VB2NwJI86PnoYk7I/v2y4NZH9Rg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsNwoS6Rr05eLdEV5aRxQJi/q179H4S1xim1DYua88BFl8pLD8
	tHx8MXsx0Lclhm0VHCDx0fFYECsm6f9KgBHEB9sxzlQnhJKiP/MXghBP4h06Yq7fu2LRLG946OA
	uZADNgFZNuDvnhe+GLEz5MTlmP3gzF3A=
X-Gm-Gg: ATEYQzw/KViolphsq+vhECFT95h0R+kBG7h3uBnE+76ps1bpuvUKFBOWubGOfYQFfZc
	CAwPcdbanrADH+00gxMb6oYQA9pE0BY0hPg6ORs/h/euBq16mS+O/H8tADR+Bfkm1l0st7I+mRY
	rsYp8aoepZWJ/qGFBq3HHKaDTsOuaYoKYkmGU8wji8XOLIleZZfl35O04veUZiYAp4lUbPK4/fa
	A4fPTO9yxXhPb7VO4NlEaoWWfoHloYUykDBT9An4qSjNXt+WeAi7j7WKwwA+EAaZmwa8cP1lSdR
	WTToBQ==
X-Received: by 2002:a05:6000:290b:b0:43b:4468:b112 with SMTP id
 ffacd0b85a97d-43b6426b65fmr8200715f8f.25.1774055970677; Fri, 20 Mar 2026
 18:19:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
 <59dcb27f-875c-4a2a-82dc-63b832f8eb1e@bsbernd.com> <CAJnrk1YLtQF=SF-GoG4irKYzzePNewNgyTeU7VLvUN6Ub_NFVw@mail.gmail.com>
 <d9aae2bf-b81d-42c8-b919-5e64292323e8@bsbernd.com> <CAJnrk1bYLwHpZsW85XiyWfM=gXXXS6pHg4=p9fcbDOwpca8UXQ@mail.gmail.com>
 <f8a1808b-4068-49a7-a17d-8dcab1ae9cdf@bsbernd.com>
In-Reply-To: <f8a1808b-4068-49a7-a17d-8dcab1ae9cdf@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 20 Mar 2026 18:19:19 -0700
X-Gm-Features: AaiRm52angp4XSylGzFu5XLXSrc6TjmoHSygxSLjL3zcUmW3aIneWHY-_S5Q4Mk
Message-ID: <CAJnrk1armV9VzBqrrdfr15K5ySBx2YJRk_P0okGnkzyMx_eDOw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	csander@purestorage.com, krisman@suse.de, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Horst Birthelmer <hbirthelmer@ddn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12774-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,purestorage.com,suse.de,vger.kernel.org,ddn.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,bsbernd.com:email]
X-Rspamd-Queue-Id: 8D2B72E2C42
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 20, 2026 at 3:44=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 3/20/26 22:58, Joanne Koong wrote:
> > On Fri, Mar 20, 2026 at 12:45=E2=80=AFPM Bernd Schubert <bernd@bsbernd.=
com> wrote:
> >>
> >> On 3/20/26 20:20, Joanne Koong wrote:
> >>> On Fri, Mar 20, 2026 at 10:16=E2=80=AFAM Bernd Schubert <bernd@bsbern=
d.com> wrote:
> >>>>
> >>>> On 3/6/26 01:32, Joanne Koong wrote:
> >>> Hi Bernd,
> >>>
> >>>> Hi Joanne,
> >>>>
> >>>> I'm a bit late, but could we have a design discussion about fuse her=
e?
> >>>> From my point of view it would be good if we could have different
> >>>> request sizes for the ring buffers. Without kbuf I thought we would =
just
> >>>
> >>> Is your motivation for wanting different request sizes for the ring
> >>> buffers so that it can optimize the memory costs of the buffers? I
> >>> agree that trying to reduce the memory footprint of the buffers is
> >>> very important. The main reason I ended up going with the buffer ring
> >>> design was for that purpose. When kbuf incremental buffer consumption
> >>> is added in the future (I plan to submit it separately once all the
> >>> io-uring pieces of the fuse-zero-copy patchset land), this will allow
> >>> non-overlapping regions of the individual buffer to be used across
> >>> multiple different-sized requests concurrently.
> >>
> >> That is also fine.
> >>
> >>>
> >>> From my point of view, this is better than allocating variable-sized
> >>> buffers upfront because:
> >>> a) entries are fully maximized. With variable-sized buffers, the big
> >>> buffers would be reserved specifically for payload requests while the
> >>> small buffers would be reserved specifically for metadata requests. W=
e
> >>> could allocate '# entries' amount of small buffers, but for big
> >>> buffers there would be less than '# entries'. If the server needs to
> >>> service a lot of concurrent I/O requests, then the ring gets throttle=
d
> >>> on the limited number of big buffers available.
> >>
> >> I would like to see something like 8K, 16K, 32K, 128K.
> >
> > My worry is that for I/O heavy workloads with large read/write
> > payloads (eg client access patterns reading/writing MBs at a time),
> > the limited number of big enough buffers becomes the throttling
> > bottleneck.
> >
> >>
> >>>
> >>> b) it best maximizes buffer memory. A request could need a buffer of
> >>> any size so with variable-sized buffers, there's extra space in the
> >>> buffer that is still being wasted. For example, for large payload
> >>> requests, the big buffers would need to be the size of the max payloa=
d
> >>> size (eg default 1 MB) but a lot of requests will fall under that.
> >>> With incremental buffer consumption, only however many bytes used by
> >>> the request are reserved in the buffer.
> >>
> >> Doesn't that cause fragmentation?
> >
> > With incremetnal buffer consumption, there's not fragmentation in the
> > classical sense (eg scattered unusable holes). The buffer gets
> > recycled back into the ring as a whole once all the requests in it
> > have completed (tracked by refcounting).
> >
> > I think the concern is that if the server is very slow to fulfill
> > requests and the workload pattern has it so that slow requests are
> > packed into the same buffer as fast requests across all the buffers in
> > the queue and that queue has all its buffers saturated, then the next
> > buffer is available only once the slow request has completed. We can
> > mitigate this by assigning the request to a queue on the nearest numa
> > node as a fallback if we detect that case. We could also do the same
> > thing to mitigate the variable-sized buffer scenario where there's not
> > enough big buffers for the queue, but I think that logic ends up a bit
> > more complex.
> >
> > I think overall we're able to support both incremental buffer
> > consumption + variable-sized buffers if there's a need for it in the
> > future where the server would like to choose.
> >
> >>
> >>>
> >>> c) there's no overhead with having to (as you pointed out) keep the
> >>> buffers tracked and sorted into per-sized lists. If we wanted to use
> >>> variable-sized buffers with kbufs instead of using incremental buffer
> >>> consumption, the best way to do that would be to allocate a separate
> >>> kbufring to support payload requests vs metadata requests.
> >>
> >> Yeah, I had thought of multiple kbuf rings, with different sizes.
> >>
> >>>
> >>>> register entries with different sizes, which would then get sorted i=
nto
> >>>> per size lists. Now with kbuf that will not work anymore and we need
> >>>> different kbuf sizes. But then kbuf is not suitable for non-privileg=
ed
> >>>> users. So in order to support different request sizes one basically =
has
> >>>
> >>> Non-privileged fuse servers use kbufs as well. It's only zero-copying
> >>> that is not possible for non-privileged servers.
> >>
> >> Non-privileged cannot pin, at least by default mlock size is 8MB. I wa=
s
> >> under the impression that kbuf would be always pinned, but I need to
> >> read over it again.
> >
> > The kbufs get accounted to the user's mlock usage (this happens in
> > __io_account_mem()). If the user running the unprivileged server
> > doesn't belong to a group that has high enough mlock limits, they'll
> > have to use regular fuse over-io-uring buffers instead of kbufs for
> > most of their queues.
>
> That is exactly what I mean - in reality  unprivileged servers will not
> be able to use kbufs. And there it would be good, if that server could
> use unpinned pbufs.

I think it's fundamentally wrong to use pbufs here. The buffers are
completely under the sovereignty of userspace. If userspace chooses to
free the buffers at any point or reuse the buffer for other purposes
(or a free() and later malloc() ends up mapping to the same adddres),
the kernel should not still be accessing the data in that buffer. When
it's userspace that recycles back the buffer, this isn't a problem
because userspace maintains direct control of the lifecycle and kernel
usage of the buffer (eg if the buffer shouldn't be used by the kernel
anymore since it's freed, then userspace simply won't add it back to
the ring). This gets worse with incremental buffer consumption where
multiple requests now simultaneously use the buffer - the server can't
know when the kernel finishes reading each sub-region and on the
kernel side, refcount tracking the pbuf becomes impractical. The pbuf
buffers are a shared mapping that userspace can dynamically modify at
any time, they can add and remove buffers from the ring at will. We
can't add the refcount to the backing buffer struct directly since
that is modifiable by userspace; we would have to track it separately
in its own kernel-private list, but keeping that list in sync is
difficult when userspace can add or remove buffers through the shared
mapping at any time invisibly to the kernel.

I agree that for unprivileged servers constrained by low mlock limits,
it's annoying that they can't use these features, but I don't think
pbufs are the right direction. I think for those unprivileged servers,
if the memory consumption is a pressing issue, then we should either
just add the variable-sized buffers you mentioned or the servers
should just use fewer queues and entries and accept the tradeoff that
running unprivileged has a lower performance ceiling.

Thanks,
Joanne



>
>
> Thanks,
> Bernd

