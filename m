Return-Path: <io-uring+bounces-12772-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OxlDyfDvWmEBQMAu9opvQ
	(envelope-from <io-uring+bounces-12772-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 22:59:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FAC2E1894
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 22:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 407153009834
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 21:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3F03AF64B;
	Fri, 20 Mar 2026 21:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WLI8XUSp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E494B36682A
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 21:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774043937; cv=pass; b=bgnx30qGXAZ4833LCKSPZE8Hzifip56TUjA6MeZJ9b4HtT3laPOaXIE+eo1dDaFBUgLv2zJoYhI7ATupDhb8DbC7VGFvg0Ad1yiazDq9i11vqwR9XSXl3xiJ+sz2lkaJlMlrHTwc1rA7Bboq70CjDVR3oFVJytqmGO5hyr3HCxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774043937; c=relaxed/simple;
	bh=taGryygV72CTK+0z5VvRQSXY37kHg1eywRtjZPhowxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RGvj01KoMlPkTgwB7CfIFhpVfLDff3tDghfMHBdQLaRKocKlr0375z+ALOnV3RZPLMOM/s+kzsM3NUVtGJkO4/2tpoX/KwJgdEGF9Zs2OpbZ9lokd1XwF4IA+BBij3t2uw+TEtdREvWEKI98l+QL/dOp86F52wx81ZWpreXGWpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WLI8XUSp; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso19710685e9.3
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 14:58:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774043934; cv=none;
        d=google.com; s=arc-20240605;
        b=YKZK6ySnPZVstqK4HHmdL0lqxeoT3KTunJeNXLo9Edl4JoRl+1/UuCUXBPaYG3uR5H
         Kx+QikGr7L9iNDEMvswNjEhVFD+7DlDqoJIpsrDaBS9X/UubCdTgXLkPNR6WYlAqRsEG
         4NYd/+HcR/nwVu6qbhyXQ8WM6UxE3x5KEv4SawP6NqdG3dcaXmenmHJ4JI/loVQcRtIP
         1wuDllNKOfIDkLe5OUkvLzYUu54g8nssenXrQpKGf2/DO449Sbmy4Wm0rTv9CS5sqQ38
         uaZfTnVI4ESh/jxRe7QBpNB9rlx6g2HX9/IQuIlSRQ2K6zfyan/4b2OPTHiDDou8eu0L
         LfSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=taGryygV72CTK+0z5VvRQSXY37kHg1eywRtjZPhowxM=;
        fh=JRT8YFIJrudtBYQNuUwgiQZ4t05sYJ/7CoySyC6kaSk=;
        b=DR7M2hKa4FUiSNz0uOQAPSh1GJIj0p5F/HJy3UYBKCdBk38lbcnTMC1LRJU3iv41u8
         YzcT4+TydQDy5HzoTbVfySIUoGQaithWojAvwNgvaFb5hWUbdQ5IRy2N9qdK63tnUC7+
         xECcwwHwuHU4rbrljOfSNzPjB9VsSQV5tSBqhwzfFIu9eObxU/fvrBXVHeSWvUcxwHDt
         jL9fKUBOj8/FvJNqiUsgXqo6oF/ARWufbvrdmNYNWgJd1JVcRQG1lxFLLtkLBFL9U/1b
         nO3gepez5UNtP9+eBQnkGBc0j/0IPRJIdxvUyETmZrVTpSN2w9cQYvNHAyD4OFbLNjfq
         P6ZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774043934; x=1774648734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=taGryygV72CTK+0z5VvRQSXY37kHg1eywRtjZPhowxM=;
        b=WLI8XUSpM7s+cuUliawRZzDsDb4r+IA1ryuw0qJy5eLr/eYV26Vbjia2lKwpk7gynU
         yorU5I4Lmurc0pTKsllqwvXA1yhrEiO2+MdhKMocLpR+r69RTheJHXB1shaOwaT8EucI
         DiYxIBz282aSkg3RQpkrYVRz1WI9JaK9YloUYwTaqDxBS0ofz5qnzs+YtdL9iyMxszo6
         QabpI+L2sfUfouJP34WJ522dskeqWzQ+yCIE+hCnkw4KWhIfaNB9C0FanePcdAg2skNd
         ytYFX2SAKPylysRSKV8pER3JEi/Gcv+YqWDsObBDHqprhBBkCR4+GjJK51lh/iBBB4I+
         0CIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774043934; x=1774648734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=taGryygV72CTK+0z5VvRQSXY37kHg1eywRtjZPhowxM=;
        b=KvjH7D6KEwEyx8YuC7TVe7Fp9qLi7E3AoKHkvebZ2tNtDx0L/T9yQheHW0EBR5qUIA
         VTGPcEy2gBRWz+KKD1a3Snd0QfzQ81LIY/EHj6gul1R2Geq0aOxUnYZHNGxboc2zsIBT
         1+wRM25uU30PfE+mc7K9yZsiRP7zoi7F8ZgCkFUzdT/By5I1wAtmRagtDUYUPjy2+Yep
         l+grBrGDE+ABit/y3xrMnRkF+orsRk1/h5xs1jjFkF85xJjyjyf1fe1xW82SndBcRjc9
         Q/2x9go8CPGIqxS8ByGNOyu/6dMwCF24bQHpZRHalFu0E+JReM0/KUfY3fbTv+HsTEgb
         8xRw==
X-Forwarded-Encrypted: i=1; AJvYcCUVvQrIT3hyElJfoIfNLq8zoq4oKEa7SZlSllXd0Jen57LWRo4I2u2RpEc/8LHI+zgifFejJmUf+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvxR34XmCAYyw1RS2hdeyHHoQpL+qz38yO6dJ2DXaD7vzA4Fp3
	DzYqwBn/imGKW7bUZ3cdHLGSPLq06F0ZukTtHoTv5SfItLov4R1O6m66Xn0R+8Cz9kiqK28R5rV
	UEbRx4epXqyG8ET3bn0fgkvZhPNtbQK8=
X-Gm-Gg: ATEYQzw0CxyuRI3WbP6NUwVGVQwrrPiWV9MmfxMflem0lBS65Yiwdxyu89LZJCMyO7R
	Ot9aiGR9B/CHiKH79GDnYnb8lQ5h52vIsrNu/J0DaQUcNoT+SCnpNklFA1FvKJ/Wzlv58xnya9m
	0jOdlriH3VXUq13YgPwubQkxy+Ou/CI7psh7Sr/HgCOImZHlvOZHZXTEVk17rtU5TdSn4xppKr8
	5SrIKnQz+aw8783Y4mSM4s2a9K1ZBM/HW84p8wR8QnrRlAUdNF9s7BUHDOdQ8EUPtr8HDwpkOer
	dhD3sg==
X-Received: by 2002:a05:600c:4e8e:b0:485:3c8f:e4c5 with SMTP id
 5b1f17b1804b1-486fee049fdmr65279645e9.17.1774043934007; Fri, 20 Mar 2026
 14:58:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
 <59dcb27f-875c-4a2a-82dc-63b832f8eb1e@bsbernd.com> <CAJnrk1YLtQF=SF-GoG4irKYzzePNewNgyTeU7VLvUN6Ub_NFVw@mail.gmail.com>
 <d9aae2bf-b81d-42c8-b919-5e64292323e8@bsbernd.com>
In-Reply-To: <d9aae2bf-b81d-42c8-b919-5e64292323e8@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 20 Mar 2026 14:58:42 -0700
X-Gm-Features: AaiRm52AHv_3nF2I3TUKZMaIl27ed6hAdjzjKQ-cJFY4iQtxORQMs2VLo42mB3w
Message-ID: <CAJnrk1bYLwHpZsW85XiyWfM=gXXXS6pHg4=p9fcbDOwpca8UXQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12772-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,bsbernd.com:email]
X-Rspamd-Queue-Id: 52FAC2E1894
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 20, 2026 at 12:45=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com>=
 wrote:
>
> On 3/20/26 20:20, Joanne Koong wrote:
> > On Fri, Mar 20, 2026 at 10:16=E2=80=AFAM Bernd Schubert <bernd@bsbernd.=
com> wrote:
> >>
> >> On 3/6/26 01:32, Joanne Koong wrote:
> > Hi Bernd,
> >
> >> Hi Joanne,
> >>
> >> I'm a bit late, but could we have a design discussion about fuse here?
> >> From my point of view it would be good if we could have different
> >> request sizes for the ring buffers. Without kbuf I thought we would ju=
st
> >
> > Is your motivation for wanting different request sizes for the ring
> > buffers so that it can optimize the memory costs of the buffers? I
> > agree that trying to reduce the memory footprint of the buffers is
> > very important. The main reason I ended up going with the buffer ring
> > design was for that purpose. When kbuf incremental buffer consumption
> > is added in the future (I plan to submit it separately once all the
> > io-uring pieces of the fuse-zero-copy patchset land), this will allow
> > non-overlapping regions of the individual buffer to be used across
> > multiple different-sized requests concurrently.
>
> That is also fine.
>
> >
> > From my point of view, this is better than allocating variable-sized
> > buffers upfront because:
> > a) entries are fully maximized. With variable-sized buffers, the big
> > buffers would be reserved specifically for payload requests while the
> > small buffers would be reserved specifically for metadata requests. We
> > could allocate '# entries' amount of small buffers, but for big
> > buffers there would be less than '# entries'. If the server needs to
> > service a lot of concurrent I/O requests, then the ring gets throttled
> > on the limited number of big buffers available.
>
> I would like to see something like 8K, 16K, 32K, 128K.

My worry is that for I/O heavy workloads with large read/write
payloads (eg client access patterns reading/writing MBs at a time),
the limited number of big enough buffers becomes the throttling
bottleneck.

>
> >
> > b) it best maximizes buffer memory. A request could need a buffer of
> > any size so with variable-sized buffers, there's extra space in the
> > buffer that is still being wasted. For example, for large payload
> > requests, the big buffers would need to be the size of the max payload
> > size (eg default 1 MB) but a lot of requests will fall under that.
> > With incremental buffer consumption, only however many bytes used by
> > the request are reserved in the buffer.
>
> Doesn't that cause fragmentation?

With incremetnal buffer consumption, there's not fragmentation in the
classical sense (eg scattered unusable holes). The buffer gets
recycled back into the ring as a whole once all the requests in it
have completed (tracked by refcounting).

I think the concern is that if the server is very slow to fulfill
requests and the workload pattern has it so that slow requests are
packed into the same buffer as fast requests across all the buffers in
the queue and that queue has all its buffers saturated, then the next
buffer is available only once the slow request has completed. We can
mitigate this by assigning the request to a queue on the nearest numa
node as a fallback if we detect that case. We could also do the same
thing to mitigate the variable-sized buffer scenario where there's not
enough big buffers for the queue, but I think that logic ends up a bit
more complex.

I think overall we're able to support both incremental buffer
consumption + variable-sized buffers if there's a need for it in the
future where the server would like to choose.

>
> >
> > c) there's no overhead with having to (as you pointed out) keep the
> > buffers tracked and sorted into per-sized lists. If we wanted to use
> > variable-sized buffers with kbufs instead of using incremental buffer
> > consumption, the best way to do that would be to allocate a separate
> > kbufring to support payload requests vs metadata requests.
>
> Yeah, I had thought of multiple kbuf rings, with different sizes.
>
> >
> >> register entries with different sizes, which would then get sorted int=
o
> >> per size lists. Now with kbuf that will not work anymore and we need
> >> different kbuf sizes. But then kbuf is not suitable for non-privileged
> >> users. So in order to support different request sizes one basically ha=
s
> >
> > Non-privileged fuse servers use kbufs as well. It's only zero-copying
> > that is not possible for non-privileged servers.
>
> Non-privileged cannot pin, at least by default mlock size is 8MB. I was
> under the impression that kbuf would be always pinned, but I need to
> read over it again.

The kbufs get accounted to the user's mlock usage (this happens in
__io_account_mem()). If the user running the unprivileged server
doesn't belong to a group that has high enough mlock limits, they'll
have to use regular fuse over-io-uring buffers instead of kbufs for
most of their queues.

>
> >
> >> to implement things two times - not ideal. Couldn't we have pbuf for
> >> non-privileged users and basically depcrecate the existing fuse io-uri=
ng
> >
> > I don't think this is necessary because kbufs works for both
> > non-privileged and privileged servers. For how the buffer gets used by
> > the server/kernel, pbufs are not an option here because the kernel has
> > to be the one to recycle back the buffer (since it needs to read /
> > copy data the server returns back in the buffer).
>
> I was thinking to set a flag or take ref count and to disallow pbuf
> destruction.

I don't think we can prevent the buffers from being freed by userspace
except by pinning them but then that would need to attribute the
buffers towards the mlock count.

>
> >
> >> buffer API? In the sense that it needs to be further supported for som=
e
> >> time, but won't get any new feature. Different buffer sizes would then
> >> only be supported through kbuf/pbuf?
> >
> > I hope I understood your questions correctly, but if I misread
> > anything, please let me know. I am going to be updating and submitting
> > the fuse patches next week - the main update will be changing the
> > headers to go through a registered memory region (which I only
> > realized existed after the discussion with Pavel in v1) instead of as
> > a registered buffer, as that will allow us to avoid the per I/O lookup
> > overhead and drop the patch for the
> > "io_uring_fixed_index_get()/io_uring_fixed_index_put()" refcount dance
> > altogether.
>
> I will try to review ASAP when you submit.

Thank you!

Thanks,
Joanne
>
>
> Thanks,
> Bernd
>
>

