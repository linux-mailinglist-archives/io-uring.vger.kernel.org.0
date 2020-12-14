Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2202DA07C
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 20:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408565AbgLNTaE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 14:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408553AbgLNTaC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 14:30:02 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D3C0613D3
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 11:29:22 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id y5so18030850iow.5
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 11:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3c339viXvQsho4rHj5p0nWBugeS6DhSzZqrHUn8ShyE=;
        b=YZwZaHEtE86sveRBLwxNjAcKliXkJrH0WhBJjqjv4c0+ujcU96PesMDA15iHtpCaRt
         hvau83uGd/2TxLtdl/6USSCYuSYvHyybFGSSPowycjBRaIS+TNXBNZSs16wjyJU+bb6V
         xzuJ5GHjqPAeJXbnGzleMOvOhMFEM00TPHfR5BmUhxUbVIx0LiKoKTdAQkA/mTDtCVir
         p3mdzrllOtBCZ2b31tkkAXD4MSuPYFzrh4rDlKI5txij74QTAyhkdJgnIdKBNYEOhqQ6
         sUCEI0ktBK6pWg5H+xUc+nAra08MpP/rcpgNtYn/o/hJjiyHPQ1tDQUfhs1UPwt6rJa2
         qU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3c339viXvQsho4rHj5p0nWBugeS6DhSzZqrHUn8ShyE=;
        b=OdJvnnCUs/4BFrS6hFzWboZJT9ej9Fcqw9av0041/wcwCkUeCueMrQPYzJUVcvFBbY
         NGZ5dFOGxE3xd1K/gpzvoPfgg+OdNU4DqAZrgh041iLiNbm8YEd7oOPOoHCbw0uC7jvj
         P/6AMmiTV4Tep5wUDnyUaGA0JezE8s6CmScnZka3LPudJ59un7EAJdbez0L0OQ7FR3TV
         SYRD6BExae0ylCakU9HqhxeRUCoHKYQawDx1hNMWmpHbl2kykqyfhuA2XjTT6/UHgXmz
         pYJQm8cO2zgbi3Jwi887lZM9cIyIf+GSYdwSb1JTpMQNTckl6rtONTgiUv/qN/U10Y0Z
         U96g==
X-Gm-Message-State: AOAM531vTQiw5Pnx4D/U9Jk5BrCxljPPOTAhn5fgzRIFiOviUfR8MLUP
        whNPzgLrlQhPhxWZRlsjMFsiwZBaQIbTUA==
X-Google-Smtp-Source: ABdhPJzSb1ZyXZiDF8zLg1CntTBiKliv6oVSg5HkFl1GPs4y0AHvAOljjl5mKiBQUJ7tgww/XELAeA==
X-Received: by 2002:a6b:d20d:: with SMTP id q13mr4553645iob.71.1607974161280;
        Mon, 14 Dec 2020 11:29:21 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s4sm9953597ioc.33.2020.12.14.11.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 11:29:20 -0800 (PST)
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
Date:   Mon, 14 Dec 2020 12:29:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/20 12:09 PM, Bijan Mottahedeh wrote:
> Just a ping.  Anything I can do to facilitate the review, please let me 
> know.

I'll get to this soon - sorry that this means that it'll miss 5.11, but
I wanted to make sure that we get this absolutely right. It is
definitely an interesting and useful feature, but worth spending the
necessary time on to ensure we don't have any mistakes we'll regret
later.

For your question, yes I think we could add sqe->update_flags (something
like that) and union it with the other flags, and add a flag that means
we're updating buffers instead of files. A bit iffy with the naming of
the opcode itself, but probably still a useful way to go.

I'd also love to see a bunch of test cases for this that exercise all
parts of it.

-- 
Jens Axboe

