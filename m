Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A77338DBF4
	for <lists+io-uring@lfdr.de>; Sun, 23 May 2021 18:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhEWQqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 May 2021 12:46:02 -0400
Received: from out0.migadu.com ([94.23.1.103]:60604 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhEWQqC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 23 May 2021 12:46:02 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621788272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+x4y6HjL2V5EaDS5G/wgu438ZQy0+K0wUarzL7E+Bg=;
        b=kqn4JzbVANR478k87xbBJD8Ko7InDuHGx1W9nOJc4mrkrhMFSgjjD1lcH7lysQB4CwamE1
        J4R96bp4IyIsb8T2//1LQH5o6LzNxxQt185ic6oddcSv8hgFgWchBaINz6wxJ/HXKqgTWx
        iLGsMvvrqmRXJqxkgIlclk+d5KBdRzy+faRzEiGBavbWEYKFZvprQfg2NVB+7yJ8wDaPcM
        LH1gjWtXMeADepuRAu4eZF+Y61jbUIV6uIVlFKr1YrNsxElo/XkAL922eBvh+kaQdmh8RX
        KqO5RLVvcweAXWqWu25/9dZXoiECOUM6qYy2ORRrGhGPSGbbRnrCGqk+8PetuA==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 May 2021 12:44:31 -0400
Message-Id: <CBKRYME7X23G.1ECMG1DI27KNE@taiga>
Subject: Re: [PATCH] io_uring_enter(2): clarify OP_READ and OP_WRITE
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
Cc:     "Pavel Begunkov" <asml.silence@gmail.com>
References: <20210523162012.10052-1-sir@cmpwn.com>
 <e7142141-9598-81bd-6d4e-e965e8a30d55@kernel.dk>
In-Reply-To: <e7142141-9598-81bd-6d4e-e965e8a30d55@kernel.dk>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun May 23, 2021 at 12:41 PM EDT, Jens Axboe wrote:
> They do, if -1 is used as the offset. Care to update the patch and
> include that clarification?

Certainly.
