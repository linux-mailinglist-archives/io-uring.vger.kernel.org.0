Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC5F33A718
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 18:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhCNRPB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 13:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNROn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 13:14:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA9CC061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 10:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:To:From:CC;
        bh=1hNG9tAJgaAXLTDgd13VOL7UJkOk18JvtGsAhiMfE/g=; b=ILlKfguCB+yx489OYlEBcQSbss
        nJ4c9lHur4aD3lcJLed425Zk8Ho1KQDmYsDhVOkqNgm6nUs23OWEex4eJ+fgoL3Keu+n2jflhMPAy
        IZcgRE3Q1XCLAkK6v2Tw7is0pjS6BGkdB6HYYB2hBTYHfjYnTrqb9GRclOmcGx+v9ACSSPFfwPle+
        dBUtrX5nwiP8MEqtXdwTcn5dfrdqex/gS5ZI5Ujf5ZTwYz/PzmhmUIOp4rd861fo/KGaQxKuIX6Cu
        lHxYy9GFH8lPaMaxqcDG+4yRIjIFTYbf0leQE+00pHGXd4vGTBwKEnYGbtDEU1JKYjUz3ZKu54Bwc
        NTvHV6PVT3mtWtiJMjANH32UUzPtwRQpRMVdbIDPQDxeMj+UFmY84h8fI+FavHbpTTcBTbHGYpuaj
        Y2x8xXBp+JvVY08TUlXWkk78+cWzDUWt7uSUKsGbEDSeixxedJ3lawKvIyKQrQCjBLc1IXOzmsSoU
        rDa9s/p/og1OIxGLm3p4jHUp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLUK6-00022O-PO; Sun, 14 Mar 2021 17:14:38 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615719251.git.metze@samba.org>
 <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
 <5c692b22-9042-14b4-1466-e4a209f15a7b@gmail.com>
Subject: Re: [PATCH 1/2] io_uring: remove structures from
 include/linux/io_uring.h
Message-ID: <44a742f9-4631-7dc5-48f3-1d07b1334c86@samba.org>
Date:   Sun, 14 Mar 2021 18:14:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <5c692b22-9042-14b4-1466-e4a209f15a7b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

> Both patches are really nice. However, 1/2 doesn't apply
> and looks it needs small stylistic changes, see nits below

It seems the mails got corrupted, I played with git imap-send... :-(

Here a branch with the patches:
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-5.12

Should I resend them once I fixed my mail setup?

metze


