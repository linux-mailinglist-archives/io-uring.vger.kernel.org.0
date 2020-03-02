Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E80175CE9
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 15:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCBOYM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 09:24:12 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:32913 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgCBOYL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 09:24:11 -0500
Received: by mail-io1-f65.google.com with SMTP id r15so3057749iog.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 06:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PACo5Ylnf7NlwWUXpbNnwLxP6xNyl17woukMg4Z+f5U=;
        b=MzTmGTJFSVEPetBZXXYsZGKRt+4IFVStmmrD9x/wRyuOE2ZmuyHJnQac3jqiptf8v4
         4MVEO0hQPHSPvnmAyKvYv46Yde8Rf6M8jmM0TFzH6yL9PizgUNgFNA6EolvVdn6cEQ0G
         EWr8HWk0kGHCc9vTcfAjVYmv9LjsXv0IUW4eXh4AFxon6xQ/U/y6dgOczszAYS0BXfj1
         DGeiLl6Il4eOoXzNPII6dafmGD1LR0x8XKQ0jwFgvMzkhqkyeg2DfpsKjQxztSn64GWv
         d17lD6Zt0or1HK1ZLhF0nB5s4XIijwqKXCJdssH5DgavcdwDhJBMIfDUzbjgj3Qxo/AN
         OeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PACo5Ylnf7NlwWUXpbNnwLxP6xNyl17woukMg4Z+f5U=;
        b=mEWllMHWDxbcb4S8eUOSUXb6QWvgCLYbZGYpEO7l4WeTM11/HLuG5ZjJT5BvG1qQK0
         TzLtA5VPpLzj0KkXkg4XvX8CIzbEhoqXVReAwatHcpZweZ1oGMmM2Jzjt1I1A2KJElIf
         WtAnernAxbQVpWXOtxQ03wkldLRP1Xxezj/pAXWbnEXMhHgDolPE49swS2n7UX75Om+9
         frOpf/c2I3nn3d6Iiw+/CBHrdhnGIgMo74mnMWuKukm3+qnyk+w+x4BV2ISLcw85LIe9
         cAgEkOdw3el75PFrNpv5ANdeLcNimUz6krYcpwweKQGZ55RDmM0QBCh2fCcO1YlTJErE
         ppQQ==
X-Gm-Message-State: APjAAAVE8dnk7gKnGIuhpvCzMLC4/IuUKU5rfMy6x5pbkbudhHGYSAed
        3MRAuVgYCv+owr+IRw7YeatTtSIbX3k=
X-Google-Smtp-Source: APXvYqzWEKcDRLKAtSq/cOl2Ho433UN3L0r3XjDf1zrgDpjTIVooJ8tuckgIZyV5fcqrtBkRru6MbQ==
X-Received: by 2002:a02:81cc:: with SMTP id r12mr13605862jag.93.1583159051231;
        Mon, 02 Mar 2020 06:24:11 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d7sm888275iog.28.2020.03.02.06.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 06:24:10 -0800 (PST)
Subject: Re: [PATCH 2/9] io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <909fe09940628654554531ea5fd2fc04b7002ed8.1583078091.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <484ff585-85eb-d42f-4a9b-b0a57112b294@kernel.dk>
Date:   Mon, 2 Mar 2020 07:24:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <909fe09940628654554531ea5fd2fc04b7002ed8.1583078091.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/20 9:18 AM, Pavel Begunkov wrote:
> To cancel a work, io-wq sets IO_WQ_WORK_CANCEL and executes the
> callback. However, IO_WQ_WORK_NO_CANCEL works will just execute and may
> return next work, which will be ignored and lost.

Applied this one for 5.6.

-- 
Jens Axboe

