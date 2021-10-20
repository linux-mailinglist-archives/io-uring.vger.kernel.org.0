Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA86B434A6C
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 13:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJTLqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 07:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJTLqr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 07:46:47 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7D4C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 04:44:26 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1634730264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLU5GgyujrunwIAazbVd8uuU+ErkdD/makPh/p6xb44=;
        b=OFEramZVNhC9JJU2buKwDp81sS2cJ/q/gyH76wt5WGILg/aMszG1LXn3Ug6jiY/sR3OG5g
        sbKuTY9dNSnAYMBL/2daq8//5wJhjDqApfhT3fJTUXE/zcpxOWxT7kelUZbSj55Oh9Qa8J
        OCfXzLG1Ez0iZFbiE3YCGw8y1wWFqagzOTe1u8dROU9HgguPU5QXcduwf8DCgdqIS5TQvy
        +uZbPZYjfa4DP2oqaVq0X52atqwte+0i+i9EB8WomVCuaY9KZEY1Z8/t4JT7JEqxkRXxLe
        x7NP/TVeRW1j1IyOc738gjQoGird4RJvVyyqD/egK3HqzfZIZwJ2oimbEFI0jw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 20 Oct 2021 13:44:19 +0200
Message-Id: <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
Subject: Re: Polling on an io_uring file descriptor
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
 <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
In-Reply-To: <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed Oct 20, 2021 at 12:15 PM CEST, Pavel Begunkov wrote:
> Not a canonical way, but both should work (POLLIN for CQEs).
> Do you have a simple test case for us to reproduce?

Hm, no, I cannot. I must have faced another bug, I was not able to
produce a minimal test case and my attempt to reproduce my earlier bug
in a larger test case was not succesful.

One issue which remains is that attempting to use REGISTER_FILES on
io_uring A with io_uring B's file descriptor returns EBADF. I saw a
comment in the kernel source explaining this, but it's a bit contrived
and the error case is not documented.
