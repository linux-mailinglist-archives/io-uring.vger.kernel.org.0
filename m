Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F186204731
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 04:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbgFWCSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 22:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgFWCSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 22:18:53 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB183C061573
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 19:18:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y18so8463198plr.4
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 19:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kLZjBPtHSAXfJtA8Ix/wp7Lto4xpgPzVeFE7SLHRWeo=;
        b=ioju6TH5Ffu+9KU8EwCkPcqaRyk9IoHJABxfa3QEOddQbV7mkY6JLK4ru+UX7432PU
         Oe/Xz9XjEXXvCq06scF5oYKTL0/fu2vgy0Wbi//raQBuDzKX/PeaPp6I1DKC74yhKBez
         u5iM4eo4iOHNbl5CFz7iBeRfc54FsawgydJChyaB6YfT1TFKtzXjkJ0sViTuZ+lxW965
         oMr7KKvpgfG86b5L2euFIiTXTBL3jF6/rUHv0eSJKg/wSygVy+EKfre1pzkFEvXCZ9rd
         9nfxz9//oFsrPUSvr2NJkZ6cAjJdPpi/16lw2F8j6TgRX4fj8Aeh6qPcYu3pq3YPiFu6
         abdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kLZjBPtHSAXfJtA8Ix/wp7Lto4xpgPzVeFE7SLHRWeo=;
        b=nagooJSNQVGF9qteV0wIVdS4er2mbcBgnBaWyXC/ax5dOBRMlZ/uIWdl+Qi1+vG4aM
         yP2qspkJBTv4LxMyNgWpMfyAyXgnnBH2L07eMncC/iRNywgUE6zEPMKIqdQwVnA9StOw
         pT5Wu2Nn9OtUNwshguYt9Sexo3NT4gKUnepH0SYw1xIGVAyCMoURiwvX/48ebtnD1GBE
         cagn4T4WgJyoOwJxGrl3wQwVUuxc7KKVJ6TsR+NZcRDLmOQjwLIH7nqnHoXEsUgQyW2l
         k1E1H5vRKVJsqt8XhGmWFXwW79orHtmIxpWisKxTplwiG8s7j7+LK1W4e9xfopERs/n3
         DIBQ==
X-Gm-Message-State: AOAM530WhYomFkN9CAvQn8du48qsSoB4x15g89AjHRuAKuZPlKnzjHFX
        6TivcwB+thsY6juQiMoC80+zCQ==
X-Google-Smtp-Source: ABdhPJz7T82FALVVA0k0BggOasAD3CrPK/UIFUIutSvLKLsMUSpURkBkNf0gzP7JZmULqdacqMhtyw==
X-Received: by 2002:a17:90a:be09:: with SMTP id a9mr20404009pjs.43.1592878731390;
        Mon, 22 Jun 2020 19:18:51 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e1::136e? ([2620:10d:c090:400::5:30d1])
        by smtp.gmail.com with ESMTPSA id u14sm16299612pfk.211.2020.06.22.19.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 19:18:50 -0700 (PDT)
Subject: Re: [PATCH 1/4] io_uring: fix hanging iopoll in case of -EAGAIN
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1592863245.git.asml.silence@gmail.com>
 <0301f35644823a01cbae87e440df7d58ebcf2279.1592863245.git.asml.silence@gmail.com>
 <95b720a6-926c-a208-e929-1d0203fa8701@kernel.dk>
Message-ID: <e05fc48b-684d-2980-3986-47a77af403e0@kernel.dk>
Date:   Mon, 22 Jun 2020 20:18:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <95b720a6-926c-a208-e929-1d0203fa8701@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/20 8:07 PM, Jens Axboe wrote:
> On 6/22/20 4:16 PM, Pavel Begunkov wrote:
>> io_do_iopoll() won't do anything with a request unless
>> req->iopoll_completed is set. So io_complete_rw_iopoll() has to set
>> it, otherwise io_do_iopoll() will poll a file again and again even
>> though the request of interest was completed long ago.
> 
> I need to look at this again, because with this change, I previously
> got various use-after-free. I haven't seen any issues with it, but
> I agree, from a quick look that I'm not quite sure how it's currently
> not causing hangs. Yet I haven't seen any, with targeted -EAGAIN
> testing.

Ah I think I know what it is - if we run into:

if (req->result == -EAGAIN)
	return -EAGAIN

in io_issue_sqe() and race with it, we'll reissue twice potentially.
So the above isn't quite enough, we'll need something a bit broader.

-- 
Jens Axboe

