Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677A0279CCB
	for <lists+io-uring@lfdr.de>; Sun, 27 Sep 2020 00:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIZWgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 18:36:10 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42275 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgIZWgK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 18:36:10 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2020 18:36:10 EDT
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 9913B9BA
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 18:28:22 -0400 (EDT)
Received: from imap22 ([10.202.2.72])
  by compute7.internal (MEProxy); Sat, 26 Sep 2020 18:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        basementcode.com; h=mime-version:message-id:date:from:to:subject
        :content-type; s=fm1; bh=N/0c3myGOCvtERQxuDPxL3FnDTHxKTQHtyUUZbC
        9BnQ=; b=XOakMzn4D5dnraDLQM91/aIscP/yYBevrai91R+AUfcAIyxqaxbUH9p
        2Gh9NqdiRm7RdJsSDumZvkhWxljoxZ10aeVBovI4yEhYEEz1Y5OCOIYxmp7UYrXY
        So9VtWtSh9HiK9okEoeW8RacHWVj8J7y2l7yePWLA84xfDTEWQVbfC2I9GhrnkQi
        TWffvObtdYJQFGWxhypIdqj/6mV2pbE7wNS2ie/zBAnVYRRW3nsletNWw9c+Av4n
        n8PK15BJnd6BBnFBgT6Qug3UkQUBib15d/tdRfrZLZHzyutjlbw7hBrOgWKWdWaz
        4Das6EShMyzAizlj8JYU+Tsnq38gX9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=N/0c3myGOCvtERQxuDPxL3FnDTHxK
        TQHtyUUZbC9BnQ=; b=iNXm6wEjqBDajcTGUif0svo7xwW1XSMn4qYNnfilqstE0
        QFLZDfuCkYnYM/OmMZ7r0A+EQcNrcl+/pJ3nTLznTmKz3CG3rf4+1WvJauCM/93T
        aPGUyF4zQklrTW+SaS61BZSCNDJxGOxgCwjjTG/geK1ierNCjDZcFjHo58l1HDwm
        hdAAGeOcz5gZE9pJ2VYqaMmgissOYQY5AA+DSiT+GxBf5qSlf4jh1unB+Fp4fMIM
        s+EMgVStS4h8fQmd014Eu+ftFu/ONLEp8erVYuhPXPcFgsdZF7EwHS1F0aYbpyYc
        3oLHdxdQeQpHCpcJlrdXrTUlMoNtid+vuUUtalShw==
X-ME-Sender: <xms:hcBvX_kw1CFUD4nO2zCE7AA6DP1cRsJSHjTGtUW7L0052yWntR6o8w>
    <xme:hcBvXy2s2ma3VE2ahb4k4GxBA5YH4K_xVSEpaNcw-uBXcvMtoePOLHSOtlg8ZdgTi
    tOLxtQQfx1aweP6xQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtredtre
    ertdenucfhrhhomhepfdevhhhrihhsthhophhhvghrucfjrghrvhgvhidfuceotghhrhhi
    shessggrshgvmhgvnhhttghouggvrdgtohhmqeenucggtffrrghtthgvrhhnpedvudegue
    fhhfefffethfeutdfffedvkeeliedvgeektdevudduvdfhvdejjeegheenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhrihhssegsrghsvg
    hmvghnthgtohguvgdrtghomh
X-ME-Proxy: <xmx:hcBvX1oVqPigaT7n9HRWkJFh_1iGG06zcs8lnR5C-6r-ZNEPidDkjA>
    <xmx:hcBvX3lfm-JKJR4yTPMhn3bVOIpsaVm45dEMZZTP7BDsUxUmIG125w>
    <xmx:hcBvX90gvkEnOds1OaLEqfTBWcyghjeWgfIvspiFeCJxm4EC5rKPUw>
    <xmx:hsBvX-BhEm5IWVz93_2IOQ0VOAD-diKXy7UInys7jq9mh5UJmEtEow>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id BA3976680078; Sat, 26 Sep 2020 18:28:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-355-g3ece53b-fm-20200922.004-g3ece53b9
Mime-Version: 1.0
Message-Id: <7d2c00d7-1680-4abc-8adf-c4517381db54@www.fastmail.com>
Date:   Sat, 26 Sep 2020 18:28:00 -0400
From:   "Christopher Harvey" <chris@basementcode.com>
To:     io-uring@vger.kernel.org
Subject: unlink and rename support?
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I've just started poking around io_uring and can't figure out why unlink and rename aren't supported. Are these planned for the future or is there a technical reason why they wont/shouldn't be.

Thanks in advance,
Chris
