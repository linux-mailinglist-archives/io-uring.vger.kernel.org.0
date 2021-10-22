Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDAF437568
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 12:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhJVK2n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 06:28:43 -0400
Received: from out0.migadu.com ([94.23.1.103]:59720 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232483AbhJVK2n (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 22 Oct 2021 06:28:43 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1634898377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2xkVPi7lAilrf37lctyjPs8anXuJZhAfMFGsN3FtWY=;
        b=np18vScfTrqrgpr1SolbIukY+sqy1ZbXDA/LnTQSKqQmVOtCFYBCNW7Bcq8JhXp1EkTLPz
        Rs1+mp4+H9JUQZxoa1cIa8mIGIqhPzJM1DsVEkW49BlxdrPFYwOOqAUnhE3FOsXt+Jt16I
        2nXyWn20jP1TAVSPaQSh/4eCWwbdwVlA9ZXvbkImtnRzpTMZjw57HKYHTPPQWFBelR7+JX
        rIeBEWCbB9mQkmmq/REhq7ERsUlRMWaVPsgbiS7n/v0XK3kwS2ePY0XlWlepLAz2ry0oHI
        kWlSh9vEZbYE263UyPDpYcw+G/YP8CO/knbiR6Y1rFS4ni1mY15SUHqc7ttMpg==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 22 Oct 2021 12:26:17 +0200
Message-Id: <CF5V3TYHMZVC.M9GAOFXLMI4T@taiga>
Subject: Re: Polling on an io_uring file descriptor
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
 <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
 <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
 <1e3b5546-5844-bbed-e18a-99460a8ae3e4@gmail.com>
 <CF47UZE6WXQ6.1MZDZ8OPGM0TW@taiga> <CF5RZ29XMY8T.2FIJ64YU0UFJ7@taiga>
 <01fd5aeb-68c9-c30d-be9c-b8ce21f2f16b@gmail.com>
In-Reply-To: <01fd5aeb-68c9-c30d-be9c-b8ce21f2f16b@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri Oct 22, 2021 at 11:49 AM CEST, Pavel Begunkov wrote:
> It's potentially problematic, even now we have a couple of other
> spots relying on it. Is there a good reason why it's needed?

Yes, I have an application which uses one io_uring to manage a second
io_uring. I can skip registering the fd (current approach) or I can use
a different mechanism for managing the second uring (e.g. poll), but it
seems awkward and poorly justified that this invariant would exist.
