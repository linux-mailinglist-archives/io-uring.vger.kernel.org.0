Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004283AB182
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 12:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhFQKkv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 06:40:51 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:58619 "EHLO
        mail-0201.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhFQKkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 06:40:51 -0400
Date:   Thu, 17 Jun 2021 10:38:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1623926291;
        bh=Pn6Fca8Hnd9hnpRKHYsVcDFVJ1S7CA5cpsOGA3G8Ak0=;
        h=Date:To:From:Reply-To:Subject:From;
        b=sCEXN4ho7hK6jjk7JvxphKM0yXJhagsV1BkAmQl3RcUQcGPZpQwXhn/nUyoTaaJ8z
         MbX3MWsobBXo4f/3RR4a/J39rw4J0PdOxsaU8V4XR7/4b4aPIZBn1yh++hP0V7NCTH
         A2E9HFhrbKcztRUsscArj20ZeiVWEeLKdJy566Vw=
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From:   "robert.j.graham" <robert.j.graham@protonmail.com>
Reply-To: "robert.j.graham" <robert.j.graham@protonmail.com>
Subject: Best way to continually discard incoming socket data
Message-ID: <FepzOp21D3FNjLor4XObZ0-0m2tiUlNcI99eIpTZsRAfLgPW0FRyrDTRAC2_JamKECcJi8NFxbCKl-VXixV7vsPZccaZw27VbYgun-EKEQ4=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I wish to be able to discard all incoming data on a socket for some period =
as efficiently as possible, while still being able to send data on the sock=
et. I think conceptually what I would want is a new socket flag, say, SO_RC=
VDISCARD, that would just as early as possible in the network stack discard=
 any incoming data after enabled (and not show read readiness on epoll, etc=
). What I want to avoid is bouncing back and forth from kernel to userland =
just to discard the data, even if we can avoid the actual data copying the =
systems calls to continually be notified and instruct the kernel to discard=
 don't make sense.

I've been trying to understand what might be the best way to achieve someth=
ing similar in modern Linux. Would it be something like submitting a bunch =
(chain?) of recv()s with MSG_TRUNC on an io_uring, or some sort of splice()=
, IORING_OP_SPLICE, etc. There are a lot of different facilities available =
and it seems like a pretty straightforward task, so I'm sure there must be =
a fairly simple and efficient way, it's just not immediately clear to me wh=
at the best approach might be.

Thanks!
