Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D78169B90
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 02:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgBXBH5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 20:07:57 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:33965 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbgBXBH5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 20:07:57 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id B47E24C1
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 20:07:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 23 Feb 2020 20:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=aWhwDAiUqAlHXO+NUv9xmMQWvuboNblyj5KKhchN7EI=; b=RGuaHXIJ
        iYIKEScf7jkkayJbrP5ByX25TNwUZK5QgEeO6n4T4LzXEscXX/JCWM/uL45hX88e
        GiqRjvjMxwc2xKw70jTtr3UM9HeLHLH5tZaw3klZbjxz2c+ZWjndjFin0zLQqPu+
        ZD73vnhREzn4zEz6H6f7kF7XA9ucfwK+s+O4eJPhlgTFC0zWrYTdorFRi+f1Fffo
        wnkFMf4rVQxPfR4Loy76bURX2bPYn2VK4QpfxjpvPzad1lzFHvL2hX9NhWItPH7I
        0dQGNE/GaajH0SnPe/VixH+ZznbWZ7hcm2dWu9cUscbU16S//4Gn+3zwnb17KI9R
        zahVuz4oYXOV4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=aWhwDAiUqAlHXO+NUv9xmMQWvuboN
        blyj5KKhchN7EI=; b=Zt0L6PKzEafMPChtaF8OnI60wDo7p9Jab5aBcQM/yqmIS
        Sctx7UE/uYijnP3Z/8128glAF/6qPjVJivmIi+i5w8lXfPqgEaCtapF/Bb5Xe/Y7
        Iml4lOHQMVTRo7lFooHgamswS3gW9oR/5dmQDTlmvysuUWM3stZgbeRT3qh6knjw
        BSxLiF/2QCvzMLw6/EspIzGQtv0W4gpbasHK0fwTljpPfu8pxhfeQWlBjjXgVGrA
        9o1qQkPEnmNRennh/aq8qXjd9Mwxduy6viWUkupfhOkJos5hSTu9wthx8zgfE2BS
        gC1LoLJ120uRv9rg3WJM8OjHugFiJTEv7oiZdpwHQ==
X-ME-Sender: <xms:6yFTXtG_x6NISF3J0AQWKStDbYZjNYj3BUGQRbG-a35klJBU_e65uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeelgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggusehttdertddttd
    dvnecuhfhrohhmpeetnhgurhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgr
    iigvlhdruggvqeenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgr
    iigvlhdruggv
X-ME-Proxy: <xmx:6yFTXp4npozQiRQjRAGrbLEN7gJeH1gg-QOINPSlTo6p9yryyCT3Cw>
    <xmx:6yFTXr2FSR6cbOUoQJWVa5Mdp7LS7A8MFsDc4X3ibKhD9TNX6Lt0JA>
    <xmx:6yFTXqR2h8D_475tsMziFebudFHBVY8BM5D6Pke03Dudmipew42_SQ>
    <xmx:7CFTXknAqeWPWLcqUt8z9Zneyvr251FH4hThgmymCKk_ixF5YayxXw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1DEC328005D
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 20:07:55 -0500 (EST)
Date:   Sun, 23 Feb 2020 17:07:54 -0800
From:   Andres Freund <andres@anarazel.de>
To:     io-uring@vger.kernel.org
Subject: Deduplicate io_*_prep calls?
Message-ID: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

There's currently two places that know to call io_*_prep() for
sqes. io_req_defer_prep() and io_issue_sqe(). E.g. for READV there's:

static int io_req_defer_prep(struct io_kiocb *req,
			     const struct io_uring_sqe *sqe)
...
	case IORING_OP_READV:
	case IORING_OP_READ_FIXED:
	case IORING_OP_READ:
		ret = io_read_prep(req, sqe, true);
		break;

and

static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
			struct io_kiocb **nxt, bool force_nonblock)
{
...
	case IORING_OP_READV:
	case IORING_OP_READ_FIXED:
	case IORING_OP_READ:
		if (sqe) {
			ret = io_read_prep(req, sqe, force_nonblock);
			if (ret < 0)
				break;
		}
		ret = io_read(req, nxt, force_nonblock);
		break;

that seems a bit unnecessary. How about breaking that out into a
separate function?  I can write up a patch, just didn't want to do so if
there's a reason for the current split.


Alternatively it'd could all be just be dispatches via io_op_defs, but
that'd be a bigger change with potential performance implications. And
it'd benefit from prior deduplication anyway.

Greetings,

Andres Freund
