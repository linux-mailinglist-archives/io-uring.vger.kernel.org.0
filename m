Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C65772A241
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjFISbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjFISbc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:32 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CBC35B5
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:30 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-33d0c740498so911395ab.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335490; x=1688927490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FVhmpEWdwQLlMdHyQ9Mhb5UMZ6OewEHpEBbO0pU6Sak=;
        b=ixyEHymWKDHBV0Te2r03eRbOxaVPPT0ll4jsBjImJcgalXeGM0mq1ASxU8w9YLRSoW
         qUbHqN8S4MAL+i66nJbyHzxzHsj0Uf2sSGXBXU2j2++SVsHNjudfE9vqm5hXAJvIvLFY
         ndqyQvnYIxi0g2w3eTHQmhT9QfzSL4ImPsIMyZ5+dC6Dzr2M8RdBXPmGrHsxfmiqnXSI
         QWpO5lJC+5sPRorUZ9hLaQsqnLR4D59vAWr67JemJ5Lu5lGPNd4jv6pQCX1/qkuXYksw
         FBsGPjYjlGZPL54AgtzPQnyLKWXqptPvcaPnsCvA9ohdWIxzmbBubQorqgSNt0DOFUN3
         quKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335490; x=1688927490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FVhmpEWdwQLlMdHyQ9Mhb5UMZ6OewEHpEBbO0pU6Sak=;
        b=FXud3bm5h5ricK33WiBb5+rzlOa055DGhJiIMD1F9PR9N3CGpW8WE6ScE7Q6x7SD3s
         om3SNG3/ZvmCPTgj5MdDjfpob5m9FF+eD4OZ+67DNbBJSJ1Z8qZ3aEuGIg/NkLOGk7Uh
         4ercBp7RN0CIyMsGSOOiqyDhuNeKR8vQnhu6lqlLTpivU1FbDTz4tM4LRUu/gK4jJUEF
         vFIcY8CEMUM+EOyScBwLdzdL/0jyQhUjvx4IRkmD+4s3oV9qFpZUxehj2peXCt90eU0t
         NYG3imajsL/rxD+Ozcu21/tS7+zVdbq1Hau+G4snukAnxzk85HPT+1E0Ky3IpGCqDk1x
         R0Hg==
X-Gm-Message-State: AC+VfDxNbp+g2vmFMK1qYY2GIBYcuAXF4GojGtM8hfo/yOOrONdA/zwm
        XfoB1zSh2lOxei4EYl3sG2Wf69zm/eFYkaO6K54=
X-Google-Smtp-Source: ACHHUZ5bpNs3pjhvyHqQeHV5/OMqfS6/kPnscViO0RNx26bLGe4mYhHFW2qERKkchE93qEx+pqqWAA==
X-Received: by 2002:a05:6602:408b:b0:777:a5a4:c6cb with SMTP id bl11-20020a056602408b00b00777a5a4c6cbmr1919882iob.1.1686335489672;
        Fri, 09 Jun 2023 11:31:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET RFC 0/6] Add io_uring support for futex wait/wake
Date:   Fri,  9 Jun 2023 12:31:19 -0600
Message-Id: <20230609183125.673140-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Sending this just to the io_uring list for now so we can iron out
details, questions, concerns, etc before going a bit broader to get
the futex parts reviewed. Those are pretty straight forward though,
and try not to get too entangled into futex internals.

Anyway, this adds support for IORING_OP_FUTEX_{WAIT,WAKE}. The
WAKE part is pretty trivial, as we can just call into the wake side
of things. For wait, obviously we cannot, as we don't want to block
on waiting on a futex. When futex currently does a wait, it queues up
the futex_q in question and then does a sync wait/schedule on that.
The futex handler futex_wake_mark() is responsible for waking the
task that is synchronousely sleeping on that futex_q. This default
handler is hardwired, and we simply add a wake handler in futex_q
for this intead and change the hardwired futex_q->task to be a
generic data piece for the handler.

With that, we can queue up a futex_q and get a callback when it
would have woken. With that, we can sanely implement async WAIT
support without blocking.

Notable omissions in this code so far:

- We don't support timeouts with futex wait. We could definitely
  add this support. Outside of some complications with racing with
  wake (and cancelation), it is certainly doable. The main question
  here is we need it? And if we do, can we get by with just using
  linked timeouts for this? That's the io_uring idiomatic way of
  achieving this goal. That said, I may just go ahead and add it
  if I can solve the races in a clean fashion. Because at that point,
  seems the right thing to do.

- No PI support. This can certainly get added later.

Code can also be found here:

git://git.kernel.dk/linux io_uring-futex

or on cgit:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-futex

Very simple sample code below showing how to do a wait and wake,
Obviously not that exciting, just a brief demo.


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <linux/futex.h>
#include <liburing.h>

#define	IORING_OP_FUTEX_WAIT (IORING_OP_SENDMSG_ZC + 1)
#define IORING_OP_FUTEX_WAKE (IORING_OP_FUTEX_WAIT + 1)

static void io_uring_prep_futex_wait(struct io_uring_sqe *sqe, void *futex,
				     int val)
{
	memset(sqe, 0, sizeof(*sqe));
	sqe->opcode = IORING_OP_FUTEX_WAIT;
	sqe->fd = FUTEX_WAIT;
	sqe->addr = (unsigned long) futex;
	sqe->len = val;
	sqe->file_index = FUTEX_BITSET_MATCH_ANY;
}

static void io_uring_prep_futex_wake(struct io_uring_sqe *sqe, void *futex,
				     int val)
{
	memset(sqe, 0, sizeof(*sqe));
	sqe->opcode = IORING_OP_FUTEX_WAKE;
	sqe->fd = FUTEX_WAIT;
	sqe->addr = (unsigned long) futex;
	sqe->len = val;
	sqe->file_index = FUTEX_BITSET_MATCH_ANY;
}

int main(int argc, char *argv[])
{
	struct io_uring_sqe *sqe;
	struct io_uring_cqe *cqe;
	struct io_uring ring;
	unsigned int *futex;
	int ret, i;

	futex = malloc(sizeof(*futex));
	*futex = 0;

	io_uring_queue_init(8, &ring, 0);

	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_futex_wait(sqe, futex, 0);
	sqe->user_data = 1;
	
	io_uring_submit(&ring);

	*futex = 1;
	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_futex_wake(sqe, futex, 1);
	sqe->user_data = 2;

	io_uring_submit(&ring);

	for (i = 0; i < 2; i++) {
		ret = io_uring_wait_cqe(&ring, &cqe);
		if (ret)
			return 1;

		io_uring_cqe_seen(&ring, cqe);
	}

	return 0;
}

-- 
Jens Axboe


