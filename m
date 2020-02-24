Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B716ADBD
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgBXRjn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:39:43 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:40364 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXRjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:39:43 -0500
Received: by mail-io1-f48.google.com with SMTP id x1so11117751iop.7
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GP6GGjntmZAxoDY2VOCjSHvJ9HhC0L4F1BxkPxzVB9s=;
        b=vFQOqKXb7tzS+sxQDWGPlAgR46c2E5FxGj0GFNVx6ajUVT4LwhKY9pW5Oanpg/73ER
         qlsbG+0HUd3c0Y+HQVI8lkrvQ9s8Av9ktmrcJ2zgk+PXKudsLuW4r9Xw2vWqCtQxfvNz
         +NeKA0+y+JZBRxRMwhLAE/o/StJHzMd35xGHJ/3dFc/HMrjuFFCMfTF0senN+SxsQddd
         2TR/x3ID1JJkCOxkHvTHuAtGPOBdjtw6fM+7R8q8aZRWOqpwIwG3NEeKxvIdRDyYs859
         aYpNb2wXDwqvd4IN3qkc2O4Q9Ox5/VAiP7dVdI8g+wGxPG3/xFWwVplMt1aPuTgICajd
         vRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GP6GGjntmZAxoDY2VOCjSHvJ9HhC0L4F1BxkPxzVB9s=;
        b=GnegCSnlb6UNl1c1NyXVoW9TuCDo/uAHmGR/lO1ET8lgj8j1HkDry5A6pvgu/B4L6p
         s5W6EcZDpIYYH4FHGVX4OJVWB5OSmj+nFplt+QSd/SpWAPC7Qfg50BJaRDsafbOEjFAr
         MZghzKZBI3yod/61Nfc1KUsTfdPLhzYBO9+No2luLlt5WSEoVLI+4v9CqTAQ06pp0I3t
         ySMWEEykJICSz/IG23AYG24rzlhKm9GbwALrMs58WzkHWQB2g+cPa8PkA8K+GRzHWZ3O
         yP+1wLi9NVBY23+NEIxKmZZBD4rm36iCXOYSHMcSna1jGZ8lH6lp64WJKuhgkkUGYmoj
         2HVQ==
X-Gm-Message-State: APjAAAV4RUhrdGgRpfiI2fJgcFY0ZU1jUoHjob09J5hIAepqSKuCwBSH
        xwMH9l7HTb1EtEv03MW9+pz3cBGgv5g=
X-Google-Smtp-Source: APXvYqz2S/oBwUOkBWtZJ8KywtlahkG8irG+2OhEQS7O0LL8TDyn8ETtvv+PfYg2hWvQjs2bUWuF5Q==
X-Received: by 2002:a02:c6d5:: with SMTP id r21mr53157332jan.129.1582565980704;
        Mon, 24 Feb 2020 09:39:40 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p79sm4541982ill.66.2020.02.24.09.39.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:39:40 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/5]  io_uring: use polled async retry
Date:   Mon, 24 Feb 2020 10:39:32 -0700
Message-Id: <20200224173937.16481-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Here's v3 of the poll async retry patchset. Changes since v2:

- Rebase on for-5.7/io_uring
- Get rid of REQ_F_WORK bit
- Improve the tracing additions
- Fix linked_timeout case
- Fully restore work from async task handler
- Credentials now fixed
- Fix task_works running from SQPOLL
- Remove task cancellation stuff, we don't need it
- fdinfo print improvements

I think this is getting pretty close to mergeable, I haven't found
any issues with the test cases.

-- 
Jens Axboe


