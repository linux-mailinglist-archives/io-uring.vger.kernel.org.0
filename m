Return-Path: <io-uring+bounces-7111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 334A2A66FFB
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 10:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5697F3BE8C2
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 09:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36D6207A03;
	Tue, 18 Mar 2025 09:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQ3l2GaE"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93C1207678
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 09:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742290491; cv=none; b=XNy6A/At8Wp5G9XvqyetRuBY/bByQXjjlNDlLYX+a2sKx5Y3jk9cNMj+HgVDcXAS6Z5+kxGVBV6cv3E5Qs9d23STOWI7Chb0FMH2azzlThBpbamUzpwIXVgb8YPtrXq0HkiWSuGOc1u+CYCn4RvT7royF/XI3st+IFN0PTTKfNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742290491; c=relaxed/simple;
	bh=av+HSqT1vGEVXStsmbat5HtshHYWrf42STMwiR4bOHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QanL8QU+maTnRBshecawWHTHCiXDvJqV6ihNmQyh+OPbRY2zwKQETh8faXCxt/Hk9LqZa8VbMcMxsmopUgw2NOTgF0tZ3LkkjPzEKtKEYEJGwAFCXl/yyUzOPmo52Sb2tIiDznkedgX4mBPG5sMWNQ+YV3T+GI+kNYXM+8+aQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQ3l2GaE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742290488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jg1BNq+K5o2rNqgozzwR04J4R/z1e0VVgXIZnUcVTKQ=;
	b=BQ3l2GaEtiMNEVC+M0wP/qr6K6JHdDeJ/0VCJFZUqj+dFPwcbzWDqjGS8qQYdS5fARsA80
	cFeDiif/t9//Qb9A48MISDclTZ7PmwndrL7or5NbcVBPcEY1O/4rMa/NJ+j0UK1P5r0oY2
	ld41iyBNjlhPwedHkhQqa8pFA8n6UP4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-PWq76X6TPBCen_s3klAw9A-1; Tue,
 18 Mar 2025 05:34:45 -0400
X-MC-Unique: PWq76X6TPBCen_s3klAw9A-1
X-Mimecast-MFC-AGG-ID: PWq76X6TPBCen_s3klAw9A_1742290484
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9D68195608F;
	Tue, 18 Mar 2025 09:34:42 +0000 (UTC)
Received: from fedora (unknown [10.72.120.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9251180175A;
	Tue, 18 Mar 2025 09:34:34 +0000 (UTC)
Date: Tue, 18 Mar 2025 17:34:28 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9k-JE8FmWKe0fm0@fedora>
References: <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com>
 <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9knXQixQhs90j5F@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 18, 2025 at 12:57:17AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> > Yes, NOWAIT may then add an incremental performance improvement on
> > top for optimal layout cases, but I'm still not yet convinced that
> > it is a generally applicable loop device optimisation that everyone
> > wants to always enable due to the potential for 100% NOWAIT
> > submission failure on any given loop device.....

NOWAIT failure can be avoided actually:

https://lore.kernel.org/linux-block/20250314021148.3081954-6-ming.lei@redhat.com/

> 
> Yes, I think this is a really good first step:
> 
> 1) switch loop to use a per-command work_item unconditionally, which also
>    has the nice effect that it cleans up the horrible mess of the
>    per-blkcg workers.  (note that this is what the nvmet file backend has

It could be worse to take per-command work, because IO handling crosses
all system wq worker contexts.

>    always done with good result)

per-command work does burn lots of CPU unnecessarily, it isn't good for
use case of container, and it can not perform as well as NOWAIT.

> 2) look into NOWAIT submission, especially for reads this should be
>    a clear winner and probaby done unconditionally.  For writes it
>    might be a bit of a tradeoff if we expect the writes to allocate
>    a lot, so we might want some kind of tunable for it.

It is a winner for over-write too.

WRITE with allocation can be kept to submit from wq context, see my
patchset V2.


Thanks,
Ming


