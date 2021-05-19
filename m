Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DC5389721
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 21:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhEST6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 15:58:38 -0400
Received: from out0.migadu.com ([94.23.1.103]:46126 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232333AbhEST6i (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 19 May 2021 15:58:38 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2021 15:58:37 EDT
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621453896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pStDIUlRcxqMYKHBviSS5E5PKsq9k78xe0IWqY18uMc=;
        b=WnMKC4p8HJCAGdyG9xUhNHDMVD5Nw1zwaN1a6Nae8xNlzypVSqnTLahpyAiSwBxoDRCZx7
        UeX13AtHbcbIhX7oHFceUmWGZ1TubksdESHu56bcmgAk3Ynq410P5KBXK7N6ogWMSMUgQC
        wN+CsgkO3GXpzQ9/oSzAvi0PTQcYEGHRkpd1DZ1ZDDeI1yuFGp6tuAeNo1W/I7l9897zkO
        E3F43VVYx+f6pYrAgHeL22pILgdiN8Olqn536H9JZ0fLQixs0jpaMVzPrJR0IN07aD6apb
        hFawmRNxihXBwmy0xv29bk29mPYcs1WcRuhTUdrFk1VeckR4q4V/gTtfTGDimw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 19 May 2021 15:51:35 -0400
Message-Id: <CBHHFOFELZZ3.C2MWHZF690NB@taiga>
Subject: Confusion regarding the use of OP_TIMEOUT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     <io-uring@vger.kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi folks! I'm trying to use IO_TIMEOUT to insert a pause in the middle
of my SQ. I set the off (desired number of events to wait for) to zero,
which according to the docs just makes it behave like a timer.

Essentially, I want the following:

[operations...]
OP_TIMEOUT
[operations...]

To be well-ordered, so that the second batch executes after the first.
To accomplish this, I've tried to submit the first operation of the
second batch with IO_DRAIN, which causes the CQE to be delayed, but
ultimately it fails with EINTR instead of just waiting to execute.

I understand that the primary motivator for OP_TIMEOUT is to provide a
timeout functionality for other CQEs. Is my use-case not accomodated by
io_uring?
