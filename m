Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2505A24557D
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 04:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgHPClc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 22:41:32 -0400
Received: from mail.cmpwn.com ([45.56.77.53]:57604 "EHLO mail.cmpwn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgHPClc (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 15 Aug 2020 22:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cmpwn.com; s=cmpwn;
        t=1597545692; bh=rJ8rMVZ4YVBL3HkV2gmjCVzLxySqt2ZPeHax5e/sVCQ=;
        h=To:Subject:From:Date:In-Reply-To;
        b=AmS1PZBTc343mHFTl4TVf5rvk3ZQJ8d1TkT0l430uWSo9t408gHS6XvVzYVw0Byp+
         s8HOXLZLN2LDc6u5xE5DMsMKcgiQ1FPnjQA5+M+oT4lTbpGcy3u98BzkqCB1Zt5sd0
         Klb4f/vOUQcEwvINOpxIzYOxkJTvYruuyEZZDs2Q=
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
Subject: Re: Consistently reproducible deadlock with simple io_uring program
From:   "Drew DeVault" <sir@cmpwn.com>
Date:   Sat, 15 Aug 2020 22:41:13 -0400
Message-Id: <C4Y2OEOLVBGE.4CAGVUPPCFC8@homura>
In-Reply-To: <46608b91-f3f7-28b1-4e56-6c006c3f8744@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat Aug 15, 2020 at 10:40 PM EDT, Jens Axboe wrote:
> Not really any work-arounds, and on earlier 5.7 (and 5.6 and older) the
> poll operation would have just failed with -EINVAL.

Alright, thanks for the info. Cheers!
