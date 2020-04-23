Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C94A1B5723
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 10:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgDWITW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 04:19:22 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:35579 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgDWITW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 04:19:22 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 8A45820008
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:19:20 +0000 (UTC)
Date:   Thu, 23 Apr 2020 01:19:18 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     io-uring@vger.kernel.org
Subject: Multiple mmap/mprotect/munmap operations in a batch?
Message-ID: <20200423081918.GA172719@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

What would it take for io_uring to support mmap, mprotect, and munmap
operations?

What would it take to process a batch of such operations efficiently
without repeatedly poking mmap_sem and such?
