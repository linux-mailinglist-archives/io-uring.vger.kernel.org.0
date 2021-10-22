Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBEF437362
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 09:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhJVIBZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 04:01:25 -0400
Received: from out1.migadu.com ([91.121.223.63]:34681 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhJVIBZ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 22 Oct 2021 04:01:25 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1634889542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHhu+3vpg4ocXopEm0sQSIz6bA/K6hfdQfK7dEW55Ks=;
        b=sPZoJbr+YKTxLkPZq1/IlNpsQsf/liXy3n3adMSo5/ljRyKs8/irb5Kzaq0p27rht2ZOkI
        iNLQUVJd8uJdGhKrLMiiaSR3KTkHdduBxF9id6cC3m7p3JzI93JxjzsQ8595u57jrDW36c
        xfoG+rMoWYoZ5Bvjdw3FISF1QSIU8JTKrEKNeyL8fx8pxRVnSmPWn3cJM+xeTeme0kmMsa
        tQLvCJUSYasbCHjh1onk00UmuQZMGhl4JS0MipD4g0lkPlfkxfQxDhhbaQh2ESX0oWAVaU
        i5CTn1ohFZP4w/vNHGBYLZ14nkEGF4c8hKESYUfXyFQ6TD0Hz9S5oEhOfvZnXg==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 22 Oct 2021 09:59:00 +0200
Message-Id: <CF5RZ29XMY8T.2FIJ64YU0UFJ7@taiga>
Subject: Re: Polling on an io_uring file descriptor
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Drew DeVault" <sir@cmpwn.com>,
        "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
 <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
 <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
 <1e3b5546-5844-bbed-e18a-99460a8ae3e4@gmail.com>
 <CF47UZE6WXQ6.1MZDZ8OPGM0TW@taiga>
In-Reply-To: <CF47UZE6WXQ6.1MZDZ8OPGM0TW@taiga>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed Oct 20, 2021 at 2:00 PM CEST, Drew DeVault wrote:
> > Surely should be updated if not mentioned
>
> That, or the constraint removed? The reasoning is a bit obscure and I
> suspect that this case could be made possible.

So I dug into this a bit more, and the constraint seems to be to avoid a
reference loop when CONFIG_UNIX=3Dn. I grepped Google and SourceGraph for
"CONFIG_UNIX=3Dn" and only found two kernel configs with Unix sockets
disabled, neither of which had io_uring enabled. Given the rather
arbitrary restriction on registering io_urings with each other, and the
apparent absence of a use-case for io_uring without Unix sockets, can we
just require CONFIG_UNIX for io_uring and remove the limitation?
