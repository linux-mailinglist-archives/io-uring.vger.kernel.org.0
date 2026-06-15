Return-Path: <io-uring+bounces-13735-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1BcjLR5GMGq+QgUAu9opvQ
	(envelope-from <io-uring+bounces-13735-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:36:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 169B2689362
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:36:14 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=bw48YeTV;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13735-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13735-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80B5C301BF44
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC8B37702A;
	Mon, 15 Jun 2026 18:34:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CA2374737
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 18:33:59 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781548440; cv=pass; b=WyaD7qHXKJ+uEuwDJHYFKaMhbwDRITg0SGICGX58uIsVn0nLNAqTGI2rz8GJK8cbGzefHwnFtj5Rk0At2jbX+ICxv1XfvXo+QGju9XddtMYto9ByneQloXuiQhz6CH30Rc7Ue+Dd5I6YckldL+AcP8fGhtP4UjjdTqm3jUgeBAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781548440; c=relaxed/simple;
	bh=g7XneMG4ELqON+K4B9niK2uZSdVVUThf1+jEXUBJ9Qs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npga6+xcEX4WOyWib164Msxdiiby5/+sSZgxIIkB28sq50y2/dGow0ZyUBANc0ieMtmMEjoHJW727JIBtQ6J+LJeAHbgBz3GbvJQIWpMuGh43NnxQlDIgddvC03fU07lVxwKSzn44ma0vlu2ao0jdsCr8KWqoVDvxHGTZkCLppQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bw48YeTV; arc=pass smtp.client-ip=209.85.210.41
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6c7fe30ffso459317a34.2
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 11:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781548438; cv=none;
        d=google.com; s=arc-20240605;
        b=PzoNh7lezGQPVvj3wmW+gp2Sxe+HUBnNJ9MYU+LUYf4J2eOwHZsNH7qJ97DkmAmW8z
         mv2Y554W6ZuE2FzmnCsMV917eKgcI2GvuGKPNXGKmtG6UViLzGgit0oZnpk3CA/d7HhH
         lOY98ZxAo4fajnY+KvVS3oE0bGlM+fXMYKQkuqYstO/J3pW5hjTM1Y0zbfFnOfWHZhvI
         WKOLQ4lY2bJGkhrpp8vviP6kye9sxN6K4rM6gc+p0z+PZv0nz6w2bny4jT2dydVke/5z
         YGZGiZRl28JfihaGrJZAYXSRQl7I/wH6TkkroVq/I1EmH5MFqV2v3eLWXUUXlE1DGFQG
         lexA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BLT7HhIW3M63RvlD4WHum02/aR7JU64QoopSpCc8EdI=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=YFQQY6CxqaQw0F+ZNwCcXSi8uNsgbg1fFLbkvIej7hv24FvzgivKFtkuYAllyTFxzK
         NVKvC8xxf6oOOSffzyweQKYUP+fIM4d8oc12PVOTMIIe98E753N8fJVIBxQMey8hKHb+
         Y49QCp9fJaMvtRHDlVhWINa15aqlpdJ30leLXyzn4ky/vH9nCwLEZRJhgK4qlCmhEyTl
         2cos8cMez8tFJg/7c1N5Y8kan51lzyoBvnNtnJnCDeq3g7In9NThkvjq6/w+F5GUTf4L
         OEBGKNlNyUr64IDmbcxjep+z6T56FPPQ41IYMkek+JE3hHc5hmgjF+uBvuApQReJiNs3
         XdTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781548438; x=1782153238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLT7HhIW3M63RvlD4WHum02/aR7JU64QoopSpCc8EdI=;
        b=bw48YeTVY9VCVy02XYc/PnQFsrKSMc6a6bNMryiE6Jnv/6ZkwVZStevz5SAZNUT/Av
         XvyL5Jp92f49lqIIxI+GbdhoG6wIUlIHx7FOQFN2EI74wm0jlDF3NcVDskGkVeIzIhGF
         L2tPZPfRGBlnwN2h0lA6ZMa+oeh4cNm4/UCSduUAVDsxOF/T0fk7vWiuG1+LDqf75sjV
         XztueFUEM4j7AFr9YmKmXoKdA3cuSwmI7mnKAQh5sX7AUdph4IAFUwtim5VdWz+qRbJx
         nA4RNLb1aOi7O+wzqNq23RlZloufwWETYJtXrZEYOlI7r6leEGS4NG8ZVLFk5yZW9gew
         DYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781548438; x=1782153238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BLT7HhIW3M63RvlD4WHum02/aR7JU64QoopSpCc8EdI=;
        b=YlUGnvM6/wnJdOdyNoP2lrSVwUwqqQqgz40IUQRN0IKVyz4PdKR79LkgubNsAgHU0/
         5N+s3ViJxG5e3TaLORIYvwdGQ6xL14e6qf+fLllUYrj0//qlFzDuYd8B+JuwVKiEczFD
         0PEU4HC/cqrLR49W3N4yWR8qh828RIPGenyvTCVS159U46GinNR4VwZu05M0udE8d7sB
         pSGtZOMiCzD5OZ9SEfHR+x/ssp2DTdNgbJArEyJL/nQVtnr2eXsIAxlmTr0e/Q8x0zQb
         t2FAhYXFkrISkKZhgs272YXp9VVz/Gh4Wgi7w83qpqh3FvQWS5cBthGd5hXxim/C8cT/
         90Pw==
X-Gm-Message-State: AOJu0YyQOho7d3uNp88iHu3HHb3WKGROFr6tCq3zTn01xEU2hOZz6TVX
	JZnwNtzcsDIAS3d+ZBjPQ/YDD6Yz+PW6v6NMrxivOZANS06aketfrcdsu82mcvPqHreNUMPp9o1
	3B7YnhP3vfGC0fRALyrsIMdIz01KdasJc7OlkKmzG5Q1HGcS6cmYzu1GGiA==
X-Gm-Gg: Acq92OFi7tn85rT5Ob4hn/O72Bbad+s2TY96MGk+v/X8Y/jth4bDZn2XYyW/SGte2my
	WOQV51m1tYagYKhTPotg+IO67wgGA4IG0Sg9CY2HKLY0iw9OjmyJRQ9ftCkP9IzCoz1l1WNX8XB
	bvcG+EUFtWc+SRHizxwWVb3CFRFJZYOtoQWq6zMZhjtYIRLSkNcmvLzLf8jJOk6DyDpPpGV2l08
	JvuAnXa1NOdo5rgYgqGGXafUdANUtWZFpLk3Rqu0i+tt3jOjTYp+IJ1ylY0QjhUh673P5LadvzJ
	gLMc3Qk=
X-Received: by 2002:a05:6820:25b:b0:69d:502c:3cdf with SMTP id
 006d021491bc7-69edc5d8d3dmr3426329eaf.1.1781548438434; Mon, 15 Jun 2026
 11:33:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
 <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk> <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
 <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk>
In-Reply-To: <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Jun 2026 11:33:47 -0700
X-Gm-Features: AVVi8Cciy-pAbIuTzYHuENXnwtigHkzEgPy-qW-r4iPSSl9-pG_g73ChMVQGrwo
Message-ID: <CADUfDZotc7tRWiYoDGu4nGdG=AR5wmZDyw8C1-Kp5BhxL=ZEmA@mail.gmail.com>
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13735-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 169B2689362

On Sat, Jun 13, 2026 at 5:08=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/12/26 8:26 PM, Caleb Sander Mateos wrote:
> > On Fri, Jun 12, 2026 at 12:37?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
> >>>> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *r=
eq)
> >>>>                 return;
> >>>>         }
> >>>>
> >>>> +       /* task_work must only be added once */
> >>>> +       if (test_and_set_bit(0, &tctx->tw_pending))
> >>>> +               return;
> >>>
> >>> Is tw_pending necessary? How come the task_work_add() exclusivity
> >>> isn't already provided by the mpscq_push() check above?
> >>
> >> It is, because the transition from empty -> not-empty no longer works
> >> for that, as the mpscq emtpies one-by-one rather than with a delete-al=
l
> >> kind of primitive.
> >
> > Sorry, I'm still not following why the empty check doesn't suffice.
> > It's true that mpscq elements can be removed from the head one at a
> > time, but mpscq_push() will continue to return false until the
> > consumer pops all the elements and successfully sets tail back to
> > &stub. mpscq_push() will return true once when tail transitions away
> > from &stub, and then not again until the task work runs and sets tail
> > back to &stub.
>
> Let's say the task_work is currently running, a producer is adding more.
> It finds queue empty, re-adds the task_work. That part is fine, we can
> add the task_work while it's running as it has been detached already.
> The task_work keeps running and also prunes this new item. Producer adds
> another one, finds the queue empty, re-adds task_work. This one is not
> OK, the task_work was already re-added when it previously found it
> empty. Boom.

Ah right, I forgot that mpscq_pop() can both return a popped node and
set the tail back to &stub. Maybe it would make sense for it to return
whether the queue has been marked empty and break out of
tctx_task_work_run() in that case instead of relying on a separate
call to mpscq_empty()? The atomic RMW for tw_pending every time the
queue transitions between empty and non-empty seems like it could be
quite expensive.

Best,
Caleb

