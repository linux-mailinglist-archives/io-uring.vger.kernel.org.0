Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54C119EE61
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 00:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgDEWYN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Apr 2020 18:24:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34789 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDEWYM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Apr 2020 18:24:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id a23so5155270plm.1
        for <io-uring@vger.kernel.org>; Sun, 05 Apr 2020 15:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cBUqwyFaaMgPDC136EdKrYKFduVaDYD9gWafLqWLat8=;
        b=EZ03bsicf8ec3VRWrGwceWMI5Y3DdUFIdjPtdlthXFEau6iJP7+PcfeoJcifHAnua1
         5TDdcQ2urw4xCp5PJhpfKgI5xyZKdeVrIG1ZPuIB3lMLVVwclfmJV8V1BGwcGnewaegc
         N4PFhfsXRZm4z9ePInwtY64N70bf6Xo415+4uVjPm4yn27luGbZ/AHdGdWegeP+Rhn5K
         l5lKApoqn2u7u3jCSXblHPzSHjevjVFxnF6phuXHWmdplcJ3HHLUgzxhV1Xh1a8dYeOK
         GbAHbKrDjgUye4WyHUA0qgx38v2pKMwWWOLHvcTQnhfTR43GxMtcTu0bMBD5H6z1iG/H
         6/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cBUqwyFaaMgPDC136EdKrYKFduVaDYD9gWafLqWLat8=;
        b=uZY3XGOXtikgHmjs5h1WX1xyaDgpnTTuAfBHVTP5Qz7f2rp7O3f/q3TxB2dHUR7ixp
         B8Up65DH/I+82frnDQzi08N2Ypzy001/j09b+QsMGAa/fEw7r8K9LETedaIjrEn31rfe
         ba0RORlRoD2rOjcyr6ScUVCKK1NwXLXbfcAJCPsCmHmPb5da3Z2NSl+13eC8RFwlmUE4
         GNE5EkWneRcgkJ9nIm3v9NMzi9uaKu+Qjl5yVYDAbrsrEED17B30k7cPYogoT+iO1C01
         iijRUwBPbIqivXztwOk38+1wPRSY7jugzGEHYlzhY6bi/6UH7xsuGSyQ6OR6rlV/mKU/
         KzbA==
X-Gm-Message-State: AGi0Pua85yXmOkW4faE1UhHS39VDBh5UC8LtZjT1NUbQ9v+DpORH5FHt
        LgV5S6ziibw5tHh7Fd9Edq9p77mw2cdVug==
X-Google-Smtp-Source: APiQypKLY6GAjok/YBhZdRycoLQmtEL+JiOwwcjY9MB0FZoQN/+QoPoBkvhsU+qv7sh2NO70lCpKUA==
X-Received: by 2002:a17:90a:343:: with SMTP id 3mr19057622pjf.115.1586125451566;
        Sun, 05 Apr 2020 15:24:11 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:5d19:ea24:5c10:884d? ([2605:e000:100e:8c61:5d19:ea24:5c10:884d])
        by smtp.gmail.com with ESMTPSA id g11sm10126763pjs.17.2020.04.05.15.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 15:24:10 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix ctx refcounting in io_submit_sqes()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c6da3fdd-541c-ba20-ec7a-6acd2ce9c3cd@kernel.dk>
Date:   Sun, 5 Apr 2020 15:24:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/20 3:08 PM, Pavel Begunkov wrote:
> If io_get_req() fails, it drops a ref. Then, awhile keeping @submitted
> unmodified, io_submit_sqes() breaks the loop and puts @nr - @submitted
> refs. For each submitted req a ref is dropped in io_put_req() and
> friends. So, for @nr taken refs there will be
> (@nr - @submitted + @submitted + 1) dropped.
> 
> Remove ctx refcounting from io_get_req(), that at the same time makes
> it clearer.

Applied, but also marked for 5.6 stable.

-- 
Jens Axboe

