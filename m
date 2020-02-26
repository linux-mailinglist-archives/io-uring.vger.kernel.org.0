Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E63616F800
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 07:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgBZGdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 01:33:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42442 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgBZGdK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 01:33:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id p18so1472662wre.9
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 22:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j+wz539euZj4MjmsDq2I8O8ooG1goAwgFXFhLimhkwY=;
        b=eNcTifV4m22YNHhYnh7gQ1OWmT904RSBbLKZE9gsSO9TLHIfaaxI58IGfDcEHX4p4e
         KsqC6RQ8xoefpCbvUy8tpuW1uZa2ELN8kDB6fnu9xxn2Txv5xpdbuyTcn+6HSRW/o55D
         ajXOvLc/J4Mz8BvBdpGqm5N1c3MQSycDj+my3X+uJo5DCVIFMFZqXx+JTO5Pocrjc+UC
         ABq0fuqSxaUkHQHEuzl4EArLH9zZSw2ixKvq/q6bAWV5gnNrrSvBCbDBOYQlAAKEV6fQ
         2Dpqy0qm13cLbNdADZzViVB9nxWGtXNgI1ncUkUjHHo2oiDMm65zv2LJ8lk7gLoh6cRr
         PtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j+wz539euZj4MjmsDq2I8O8ooG1goAwgFXFhLimhkwY=;
        b=p4DlWdwuch2d0AIt6W8/j1VSi8mOXcXe5BW12rqPa+sSRs2Warq3eoVTxwSfYo9+Bo
         JzEj7mqL/1kIm0bNFwmEibvrE+cY7zA3bakdFViEriFfc1HlCwDOEOEJMQyAuh1/n6/t
         OnehEL+Hbcn+SSJ8Y/rbZXZPE3SdTbvIHiNOsee/lhQ5TlNCVIW+dOkKxbrJ5CRzLY8f
         n2WjO+nK+679ToEkYv0gbEQdBtYKI6hGGvAKpEmSt3vLy/S2fZyp0rDpaxgOsv8ZBJPH
         tZkvDep68dkFmyZebZ2oc+kaIDNfuLSE33n8oZN2hbiU1Oo9OUMAakefaIzdV/6tDEal
         8hNQ==
X-Gm-Message-State: APjAAAXC95TFF9C5Aigsa6wKDhP3H8Po+FiFbJfnXHqeyOEtMOYVzf1h
        jhQW269kLe+AW9xS4qv7l3CVBEEU
X-Google-Smtp-Source: APXvYqwW7mAaq3FuFly9+TA80oAYSGbfIP6d5hH/Hq3BJqqkfm6xe5R7Eoi/Dz75/sGTMC7r6wTuWQ==
X-Received: by 2002:a5d:5303:: with SMTP id e3mr3445497wrv.274.1582698786735;
        Tue, 25 Feb 2020 22:33:06 -0800 (PST)
Received: from [192.168.43.62] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id m19sm1538233wmc.34.2020.02.25.22.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 22:33:06 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <f5cb2e96-b30f-eec9-7a0b-68bdfcb0b8e2@gmail.com>
 <6c476531-7ba8-1c2a-66c3-029ad399f0b1@gmail.com>
 <0f2fd3ba-81e2-1a54-03a7-dded262a0c9f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
Message-ID: <25e2d7ed-c82d-f541-be82-2cc97ea66a4e@gmail.com>
Date:   Wed, 26 Feb 2020 09:32:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0f2fd3ba-81e2-1a54-03a7-dded262a0c9f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/02/2020 01:24, Jens Axboe wrote:
> It very much can complete the req after io_read() returns, that's what
> happens for any async disk request! By the time io_read() returns, the
> request could be completed, or it could just be in-flight. This is
> different from lots of the other opcodes, where the actual call returns
> completion sync (either success, or EAGAIN).

For some reason, I've got the idea that it do the same things as
__vfs_read/write. At least I don't see the difference between
io_read_prep()+io_read() and new_sync_read().
Thanks for the explanation, I should drop these futile attempts.

-- 
Pavel Begunkov
